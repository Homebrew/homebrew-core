class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.10.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.10.0.orig.tar.bz2"
  sha256 "95dbabe75fa5c8dc47e3acf2df7a51cee096051e5a842b4c9b6d61e40a6177b1"

  bottle do
    sha256 "fa40434b7e39fb6fd15f67ea757c9b18f3e3c0cdb0eb533940517d51793e3cfd" => :mojave
    sha256 "ba20aa21492d9b334cbf4f1dc2ea072d0302f8a97fcd2537fc38f2539e4a19b8" => :high_sierra
    sha256 "5ef7f508f0b6a8bb688b417abd865e53da69dea0d5e048ba0da0686bd2a67043" => :sierra
  end

  depends_on "pkg-config" => :build
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
