class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.10.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.10.0.orig.tar.bz2"
  sha256 "95dbabe75fa5c8dc47e3acf2df7a51cee096051e5a842b4c9b6d61e40a6177b1"
  revision 1

  bottle do
    sha256 "296e517c02d381101befecef3700d17c12a9542dd0b105912f304846a7d54fb2" => :catalina
    sha256 "183d889ae94650931d7ed470ec643a9e5b02843e037a97de2669f2d48076e996" => :mojave
    sha256 "dc9d49486a627330931c0d2caeb6af4629e3871bdbff840ae33e5afb97c087ba" => :high_sierra
    sha256 "73e3e3c27b72b36ed733b01435dd4eb9538f036cf1a817d48a171e58b70de395" => :sierra
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
