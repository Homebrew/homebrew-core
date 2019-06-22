class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  sha256 "d4b23e47a9e784a63e029338cce0464a82ce0ae4af852886afda410f9e39c630"
  revision 1

  bottle do
    cellar :any
    sha256 "4b37f3572bba070c1062b94b5b6019dcdbb64f03780a43613e6d74620405862b" => :mojave
    sha256 "24f3c015135a49e76a1ab12748bd7809a82443ddc21f60af30cc495df2f31b28" => :high_sierra
    sha256 "aa37cabf40063adf1a99a2e56858144d1811d656f3448bc652d8d69a42a80398" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => [:build, :test]
  depends_on "qt" => [:build, :test]
  depends_on "swig" => :build
  depends_on "cmake" => :test
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
    (testpath/"CMakeLists.txt").write("find_package(QGpgme REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
