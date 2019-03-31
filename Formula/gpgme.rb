class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  sha256 "d4b23e47a9e784a63e029338cce0464a82ce0ae4af852886afda410f9e39c630"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea06301a5f59abbc2274e6dd26825940faa83fa1454b7ac11f23682667d7b643" => :mojave
    sha256 "a5cb71352d5f494a8e00cb8d410a65e6300aeb5d2ed4049523fd39f3b519241c" => :high_sierra
    sha256 "e7303c04a642d079c366943e6ed011edf90651dafd425767fe87885d8cc29025" => :sierra
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
