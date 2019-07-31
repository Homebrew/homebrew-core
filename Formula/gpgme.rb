class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.1.tar.bz2"
  sha256 "c4e30b227682374c23cddc7fdb9324a99694d907e79242a25a4deeedb393be46"

  bottle do
    cellar :any
    sha256 "efd801521786032763050f3cc89117359b59d351792202d0785dd6fb86e87f3a" => :mojave
    sha256 "f487ac8f1d921b559bf2472cae7939f980c31baee10674ecc6a245473f936c5a" => :high_sierra
    sha256 "e25704cd86fc95fc9e630c0631729eb8315d8c7d27dc45abd0b08fd6d2d6937f" => :sierra
  end

  depends_on "python" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
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
    system "python2.7", "-c", "import gpg; print gpg.version.versionstr"
    system "python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
