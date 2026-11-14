class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "01ad55d1373ff310411e3d9ae05e4fde9646d137844976e808e9a81a5132b093"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8efeb272d397ba82e1c210d3ffb7be29385a8468f463e664ebab2468e8efa015"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a5598b74db76d49161ced484a4eb41bc80a0121159096884c11f0cfb95c8960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8370a18be055af991a11790fb1b2d20ee52298f68c0ee332ba6b778ea191b0f9"
    sha256 cellar: :any,                 arm64_linux:       "c49adf0100f49ab70e966c747b0be7aa347e826fa3f06c9114eefce22844a3aa"
    sha256 cellar: :any,                 x86_64_linux:      "a8d632a1eb8c80ece3632712506510a23fab642c8d40d31dc582115f3a9df60f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl) if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
