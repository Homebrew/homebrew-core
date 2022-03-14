class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.17.1.tar.bz2"
  sha256 "711eabf5dd661b9b04be9edc9ace2a7bc031f6bd9d37a768d02d0efdef108f5f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fa9c9596573a776d4775e64844f725e7709ec1c0463bba67580e79a47fc57ce2"
    sha256 cellar: :any,                 arm64_big_sur:  "1752f1a4412b47fc3fcf2144ad98c61f191293df9cd0dd927d4f555b12d97489"
    sha256 cellar: :any,                 monterey:       "18893c493073d693c73e9b9f1f1c2201a63af44acddf17a15a20bffa857db756"
    sha256 cellar: :any,                 big_sur:        "702aa2a55f6613946cbee4542500ea3f58cf7744ea0ca6e94bb3d9e26668b347"
    sha256 cellar: :any,                 catalina:       "b04b768b07c6a2957034ad472e0ffea68becd592364e6a8e768b805e53d2ff98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6315a9725a441e3ac230165a242b88350054060570d6e3b4326ec697273a6d"
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = which("python3")
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when distutils is no longer used. Related PR: https://dev.gnupg.org/D545
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
