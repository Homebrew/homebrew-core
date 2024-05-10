class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.36.tar.gz"
  sha256 "5023fc241e28ddfd36f607ba26f7a2ffd779095510832715193a1155c0bf5734"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c547d345358cd629f7175c88717959a5c6739fbc22ff218f6168ca9985931c80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b86cb99f4398bf8497f28cec3000267dc324e25b4d23e86f9286ef786c59a39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24c0cf04c06729396e8ad86d43d4647f73551b4f6424a24190f0fa38ef88b3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5a4a2120f93d2849e450826f36c57c7cde4f6bf10f6a8f815eb7e57fedcc0a6"
    sha256 cellar: :any_skip_relocation, ventura:        "cb99d15025f09248c654c9e928aae0481b036439f4a4020015c471389fdc391b"
    sha256 cellar: :any_skip_relocation, monterey:       "24ad74a3638efbb7005fd2ec5aaff8994397891033507e277a4f8532f6fc48ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aab4c6d72e00715326c6b38df2ab015d207847d2aad9226ec7aa9111279003d8"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin"/"erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath/"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}/erg lex #{testpath}/test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}/erg check #{testpath}/test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}/erg --version")
  end
end
