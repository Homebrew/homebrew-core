class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "3c391f26c5b7652a39e0ac9ec7f213e93c6c5a82d6979e807c42690fb0e67eaf"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6216b1fcb162da1899839d44e2cc3815e3598999afbdc7ec4f89a3d993827478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d23aa547590a46a809eb52815f94e1c26a6978a12f9fbb7190245ccc9d356b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9a8885e4608c22ff950485823757ec053fa6397213aef78c299fb70f3fb4e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d01870e44f15a2dc418c011cd4d6bf24efae113d286e3bc4f36e4a4ea152c1db"
    sha256 cellar: :any,                 arm64_linux:   "d5de713505f775b048c40f01566dc2a8b32a636b8b495551d318eb1f34ec56ab"
    sha256 cellar: :any,                 x86_64_linux:  "316556fa294a8bb05602c6e2024abf00eb93f697c15a806c12dcd4025aa0243a"
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
