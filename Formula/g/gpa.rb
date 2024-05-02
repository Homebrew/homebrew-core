class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  revision 3

  stable do
    url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.10.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.10.0.orig.tar.bz2"
    sha256 "95dbabe75fa5c8dc47e3acf2df7a51cee096051e5a842b4c9b6d61e40a6177b1"

    depends_on "gtk+" # TODO: Switch to `gtk+3` next release
  end

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "61cec27ce8123b84e46f47630a9167e70b30c9ef6166c3a62260f242e48b4969"
    sha256 arm64_ventura:  "1b4cca4d1ed836422734ca61db7900a99d7e2f9f7149b004dedef0c138f1dca8"
    sha256 arm64_monterey: "f9f340091302287952e582f36bbe28762de66004dcbc430d7995d773e6417904"
    sha256 sonoma:         "2686eeaf74794536fac813bbace0ab49100de3a53e8839fb2756b9cc4ec2275f"
    sha256 ventura:        "c20a1ab617533f04bd338f57fa9ccd8b0e299faff92b080a9bbd05ba3a1b4a45"
    sha256 monterey:       "b64fce454547afc4392698cbacb5780f05923ab26baf60843e68766d4817f10a"
    sha256 x86_64_linux:   "a0ea367820fa2702f1f04dde97fb0fb8632dfe69221148a3a2bd0dba1170c818"
  end

  head do
    url "https://dev.gnupg.org/source/gpa.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk+3"
  end

  depends_on "pkg-config" => :build
  depends_on "desktop-file-utils"
  depends_on "gpgme"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gpa", "--version"
  end
end
