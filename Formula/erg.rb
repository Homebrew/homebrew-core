class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.16.tar.gz"
  sha256 "e6fe68a21d8f06267ccbe2b4941062794dc021a68094cd02a89fb866029389e9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e304353947f8d44283911dcb2fd3e454c4dd5eb17a4ba17b7741df0ca9bafb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65fde242e84c2027add67142dcbc8817107eb250b5a68f40bdf15c71db2c26e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebadb3cfb61f7aa7036336c9569ffc82a6a97fa2d39938043204eecd7561f4d4"
    sha256 cellar: :any_skip_relocation, ventura:        "97fa0e8dc6ba2768d17060cd7d96f24f4a1fad928fdf15f6687dd27bee8cc017"
    sha256 cellar: :any_skip_relocation, monterey:       "683341bd7dd22d79c1b96ff218ebfa49b37766cbf8e87775694abf9211502fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c485725c6ce57b01c7ee853fb05505edfd2715e466da625a184012a63bc6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c4f116c9cd64c32ab561c2bdabef297fa5ffc7d7ba1913e42314affc6dbb0c"
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
