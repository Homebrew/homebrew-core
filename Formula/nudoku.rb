class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/0.2.5.tar.gz"
  sha256 "1478c339409abe8f1b857bf3e54c5edbeb43954432fb6e427e52a3ff6251cc25"
  head "https://github.com/jubalh/nudoku.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "870aa64540cf2bae6d49d983615c562618f141c3c4a807abf98eda7715df43b8" => :sierra
    sha256 "ea861756fb383524cdbf08ea0b7a432b6d0d85be5254bbd4b986126e49821276" => :el_capitan
    sha256 "74de3c6c3589cc42e9f74bad4610d7a055245465ad6ff45401052052a8c67917" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
