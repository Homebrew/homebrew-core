class AutoconfAT264 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftpmirror.gnu.org/autoconf/autoconf-2.64.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.64.tar.gz"
  sha256 "a84471733f86ac2c1240a6d28b705b05a6b79c3cca8835c3712efbdf813c5eb6"

  def install
    system "./configure", "--program-suffix=264",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    cp pkgshare/"autoconf/autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf264", "autotest.m4"
  end
end
