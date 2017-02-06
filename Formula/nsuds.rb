class Nsuds < Formula
  desc "Ncurses Sudoku system"
  homepage "http://nsuds.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsuds/nsuds/nsuds-0.7B/nsuds-0.7B.tar.gz"
  sha256 "6d9b3e53f3cf45e9aa29f742f6a3f7bc83a1290099a62d9b8ba421879076926e"

  head do
    url "git://git.code.sf.net/p/nsuds/code"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/Makefile", /chgrp .*/, ""
    system "make", "install"
  end

  test do
    assert_match /nsuds version #{version}$/, shell_output("#{bin}/nsuds -v")
  end
end
