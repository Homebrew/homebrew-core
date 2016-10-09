class Hesiod < Formula
  desc "Library for the simple string lookup service built on top of DNS"
  homepage "https://github.com/achernya/hesiod"
  version "3.2.1"
  url "https://github.com/achernya/hesiod/archive/hesiod-#{version}.tar.gz"
  sha256 "813ccb091ad15d516a323bb8c7693597eec2ef616f36b73a8db78ff0b856ad63"

  depends_on "automake"
  depends_on "autoconf"
  depends_on "libtool"
  depends_on "libidn"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hesinfo", "sipbtest", "passwd"
    system "#{bin}/hesinfo", "sipbtest", "filsys"
  end
end
