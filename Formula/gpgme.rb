class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.9.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.9.0.tar.bz2"
  sha256 "1b29fedb8bfad775e70eafac5b0590621683b2d9869db994568e6401f4034ceb"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "59ed12ca3804d99167a902d558b929c1dbe9167a167b7977351f747fb168c19f" => :sierra
    sha256 "e536a4999c5e9f22a6dcb21b6b28918008b9eba1e5b6b2919f0b243dc7d77b0a" => :el_capitan
    sha256 "dc03417ea2d4543a5b0b2d40bfc262af6b5f8ca036c3ab7cd495450f17f72255" => :yosemite
  end

  depends_on "gnupg"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  def install
    # Fix incorrect shared library suffix in CMake file
    # Reported 25 May 2017 https://dev.gnupg.org/T3181
    inreplace "lang/cpp/src/GpgmeppConfig.cmake.in.in", "libgpgme.so;",
                                                        "libgpgme.dylib;"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
  end
end
