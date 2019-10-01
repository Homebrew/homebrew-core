class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.1.tar.bz2"
  sha256 "c4e30b227682374c23cddc7fdb9324a99694d907e79242a25a4deeedb393be46"

  bottle do
    cellar :any
    rebuild 1
    sha256 "81b33b4c78fa21c135798a5eb12f50506613eb329e7a381b7b83a9066db11542" => :catalina
    sha256 "2a771556a334f9ad4603e83db53cbfacf53d80dc53420f244f0e3bd73afd576b" => :mojave
    sha256 "af1c3963c888a5ee9abfe38acc31039e3da2f2d2ceded165cc6d92374ec6a794" => :high_sierra
    sha256 "11c95397d0da8b17414876c65a8085cf0ea826939c202d7f677c93bc7efba20b" => :sierra
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
