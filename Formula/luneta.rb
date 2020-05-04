class Luneta < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/fbeline/luneta/"
  url "https://github.com/fbeline/luneta/archive/v0.7.2.tar.gz"
  sha256 "e84956500c6ccac63b0cc2969d82cad09ab8689a304c571b783f4244aeee5b61"

  depends_on "dub" => :build
  depends_on "ldc" => :build
  depends_on "ncurses"

  def install
    system "dub", "build", "-b", "release", "--compiler", "ldc2"
    bin.install "luneta"
  end

  test do
    assert_equal "hello", shell_output("echo 'hello\nworld' | #{bin}/luneta -f hl").chomp
  end
end
