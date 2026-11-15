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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7cbdc312265db1e48189f8726c21ffdd28f05bfd82cef861fe5a9a37a1996d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68af5e251bb9c3b29f7081366ff42e52fbaa69edbe5cd60354e0f22d3cc0fb5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36431bf9cdd3c6f5652a4a6af64e5b0b814895acb33a7f1153c44a35691f655c"
    sha256 cellar: :any,                 arm64_linux:       "094c7388087b4ca3122866fdff688a6e00561f2f2bdbbbcfaef7c94432b968d8"
    sha256 cellar: :any,                 x86_64_linux:      "78a6a5e9125c239c8bd21b0052137135279065eea9043ceb250cfddb24cab2c6"
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
