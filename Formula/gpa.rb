class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.9.10.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/gpa/gpa_0.9.10.orig.tar.bz2"
  sha256 "c3b9cc36fd9916e83524930f99df13b1d5f601f4c0168cb9f5d81422e282b727"
  revision 1

  bottle do
    sha256 "9fb1dcb581733874ee4b46aa91ac4ed8cd001e2c10c8e5cfb2341dcacff4f4c5" => :high_sierra
    sha256 "89232c9cfa56944493c01cbfd7a1998dedc3c502b656202efddbb6100b9ace3a" => :sierra
    sha256 "a1828dc36ed112f757f6f6b17917addd9e6356d475747765f58f363ba60bde29" => :el_capitan
  end

  depends_on "desktop-file-utils"
  depends_on "gpgme"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gpa", "--version"
  end
end
