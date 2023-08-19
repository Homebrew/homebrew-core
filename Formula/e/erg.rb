class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.18.tar.gz"
  sha256 "6ace0da09782f8a200bb35ab3280edd988abdb0f05ef62f335a3863074ad2a8b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8848b56ea81ec963a1953e61fc664400c1f51cba475bb90f8a7c21baea4b164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6927b03d1096af065ded4cd6e7a04a890e76ab8a3989dd8132c6fcf3314256e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f489267d8ca987c9996ca6bec7b803e08e21db114048f59604be149816219eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "60357a0dd67f336ccb6fc86d53263f13b59ed10ecbc1b0172e7df95dead09423"
    sha256 cellar: :any_skip_relocation, monterey:       "b97479122767d3b36925006f90ddabd9ce267166bb31c8c12886efa215aed1a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7978266e60be4d10ef58c2c41e295898f7a56764de490da622792f432a5e01e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d435248a7e3306b0d3453d2ae84b0e5729aa864f36124e2540e676b1e8f7d00"
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
