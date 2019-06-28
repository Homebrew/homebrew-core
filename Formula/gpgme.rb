class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  sha256 "d4b23e47a9e784a63e029338cce0464a82ce0ae4af852886afda410f9e39c630"
  revision 1

  bottle do
    cellar :any
    sha256 "bed4b8e9812a1d284b08ef2ad119b878d15890df993260eb763d885cc8d06e57" => :mojave
    sha256 "00b1378847f4af823f953cf0a44d2739abdc5727c9dcf43c9a332e9b99f8fa17" => :high_sierra
    sha256 "84d4d210a828e93794ee4cb846b6d6589f777657fc1437c4f0fe1db4f71a807d" => :sierra
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
