class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.14.0.tar.bz2"
  sha256 "cef1f710a6b0d28f5b44242713ad373702d1466dcbe512eb4e754d7f35cd4307"

  bottle do
    cellar :any
    sha256 "85e3bca3de90a091853a056a40fc22778d3a75abb4297064edae1fc07eaefdee" => :catalina
    sha256 "b49b55062ab1ba7a6994ac8506aeec65ba5acd512fabfa696148dd7b08acb1d9" => :mojave
    sha256 "c4bc2011b6afe87a0f3d76c43c50c117c1640eaa848c7a4f7be0f92e261017a7" => :high_sierra
  end

  depends_on "python@3.8" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

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
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
