class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.4/joe-4.4.tar.gz"
  sha256 "a5704828bbca29acb9e200414fef522c66cdf9ce28150f402d6767da43460979"

  bottle do
    sha256 "4c2981014abdb5b86da5427e2fc274d596e3b33539ea27c4fcae58562b1393c2" => :sierra
    sha256 "7d645771891a181a0db72b11724827c7d7c25f10d2cae2730ac6fe7f190256db" => :el_capitan
    sha256 "669e06a1ce0eda63a58daf56823b637984fc109af782dbd1035ea1d2ca19bf84" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
