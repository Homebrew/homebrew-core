class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "436b1e11518e452ba0e6109f620cc574a143bb7e564c68636bc4213e3fc4fd6d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a87b3a8affa476f796eb4decfd2e4d855f4a42cff1232655312a5f6dd9b9408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb14c4e8f8105e4a16becc577cca22876cfe10c3e49700c780a83b9049cd5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e3ebf615167dd7289601382780d27df0bd2b9bc63f81a13e9002d1ce92d3c8"
    sha256 cellar: :any,                 arm64_linux:   "f8be87a9a736958b72e3f0098335b1976f47bb5bc9cf19d4d6e16365340cded2"
    sha256 cellar: :any,                 x86_64_linux:  "68a6350732fa16b838ae62c95d323604e84d871e611e1984ceb639558ca74b14"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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
