class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.45.tar.gz"
  sha256 "9903824c41639661c94e312e0d6af3a2b16fa127f9b6afea34d5e85080a9602d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b5566c30429844fec525f2fcb2652ca9a90450441a68055e5e9d4b449fada1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d2387c388ba4a8ad530defe1e94620acbb680739bdad1587c6fcb44842e5da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad2468ad77b2764320197bbc14c8821213a5e34fcf4d74bd9e355f124ad9692b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1cbfff760d8938e5ca145b8503b55688104568fd896052d629e434002ba1806"
    sha256 cellar: :any_skip_relocation, ventura:       "9b742df9b5fc960e8291b973d06630684a1826cf911834a1dc963e37a28381a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9b32d7eddc4e15c4a50fd32774f7ae460b8bc0de68cff137c206054cfed96f"
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
