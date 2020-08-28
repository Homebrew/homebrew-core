class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.14.0.tar.bz2"
  sha256 "cef1f710a6b0d28f5b44242713ad373702d1466dcbe512eb4e754d7f35cd4307"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "9adeee9e826faf7e4955cf5e7da6a3c17b6c31a8c96b27eb486201db01fae024" => :catalina
    sha256 "8d5d6da3d5161f149e2b1b724b058f46c98c444af366a11165fb3cb2afd7cdf6" => :mojave
    sha256 "370890e7494a7be13e88493520715c48d2d45217daf0419594c1e78d06c6d8ac" => :high_sierra
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
