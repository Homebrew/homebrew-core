class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.9.10.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/gpa/gpa_0.9.10.orig.tar.bz2"
  sha256 "c3b9cc36fd9916e83524930f99df13b1d5f601f4c0168cb9f5d81422e282b727"

  bottle do
    sha256 "858ba357b188c140d61ba5570b0237a827b0a3bea3d4a87ac7e9aaa95e397230" => :sierra
    sha256 "91271433b3ff2c4de071f2dc9fc1dacdc9957b6d4075211d913d61f7d2c02ed4" => :el_capitan
    sha256 "fb0e954550a5a90a492afc6f31c13a4d96a4a5b462228a46ccbf133e62e7497b" => :yosemite
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
