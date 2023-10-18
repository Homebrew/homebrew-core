class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "d9ea9def0f4d026c9e6d7dca3d049816128e4c1874ca6aca56724503c9041fcf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c69c1f3743a046add8d3bc18f7c71a477d4f6cd6e0e10200f025bc14475fabe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dad6d113b45c446b6edf4023a2136e4b8ddc3098ee257856d457e24ac5c318c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fe009a058dcca88f14b5e65f2b862add21f18fad3e9af3afc6d8d28b6e9414f"
    sha256 cellar: :any_skip_relocation, sonoma:         "60fe926c84a9d78eb1a6da4b889e44931a311c92d57aa181e3d28035335e2444"
    sha256 cellar: :any_skip_relocation, ventura:        "72423d6db3a375d8a0aabcd3352abf04b14bfcef2e6156fa2087316ac2082bf7"
    sha256 cellar: :any_skip_relocation, monterey:       "d2587372e6b257ab745932d515a2577c01238a0019d36ab819c07cf0ac551946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e8e69a3d68227e7934749f7a23354395aa48dab547c59a26794d1c0806f350"
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
