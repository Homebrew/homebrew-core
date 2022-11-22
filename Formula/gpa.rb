class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.10.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.10.0.orig.tar.bz2"
  sha256 "95dbabe75fa5c8dc47e3acf2df7a51cee096051e5a842b4c9b6d61e40a6177b1"
  revision 2

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1f824940f9f8cc87c48a418692a80d9819de7690b29982cdb768f0d13ff68459"
    sha256 arm64_monterey: "0632898dac3f09ee39856db86625d0b4eca39e309850d4579daf9be230ff9af8"
    sha256 arm64_big_sur:  "77f73e7161f535ed00a02c8df2f5818dad8574a0ff52f339949b1030a0bd7454"
    sha256 ventura:        "0523987f802bfcc47cb082984ae591c871e3b4f9623cd29f734d173a833d217d"
    sha256 monterey:       "28a9fb24ea01ea5cc3d0e212c516b3d72a994ce70e339d911d7828f9be949669"
    sha256 big_sur:        "b4476f76bdd1e9b7acb836a49cb7e216726d277d04d24ce1b5c2d3d7e392adf0"
    sha256 catalina:       "c598e546d83f042d3de1011bff926a839c34e56c06a4c9cc6dbab25ff9c19df6"
    sha256 mojave:         "14eace8606e49fe9d3d2fa39a9f79fbbaca7cff7d78c0cb7027033f92133fa04"
    sha256 x86_64_linux:   "1a17d322fea230c75e6578aeab62b9a757bf0bdd26db04e7d1ec9277ec41c39e"
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
