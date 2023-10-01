class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.21.tar.gz"
  sha256 "2328c619ddd57490b8808578e0365133e19ff685184243cd467e61252bbc295d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0c32fd9524d770253dce5642cfd02f3acdff48fe9e851f0b26b6bca7d1dcc3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eea1d47d916cac87e7676dbc10071527264653a62cbf01da9bae74ff60a2b50b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bebc2ca4882754accf6d65de38096082ebe3bed614da1a14e8a9f469d7b98a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abdbb377a812028c2ec4eaf5a47eb4b405b72964066f3d08b56a890a6d79a9d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "919bec61ad929f3c6f788d18b375567bc8b2647c11a00229c6329b2bfb45214e"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e8b3768e9881e1bf6e5b16c017ddf477890da7ccbadbb4e98a364166816649"
    sha256 cellar: :any_skip_relocation, monterey:       "0f8b0e2bb3430006c0b8c9e394d63bae46559a756799a485de369896e370262a"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ebea9ecd2d112ab631825c362f4617c81d4a6885136c4ffeafae3da67ba75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9f760ebb66496559893b77a24880367d2f148762f2531a25f3d93de7abad38"
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
