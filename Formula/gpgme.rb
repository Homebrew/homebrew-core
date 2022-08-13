class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.18.0.tar.bz2"
  sha256 "361d4eae47ce925dba0ea569af40e7b52c645c4ae2e65e5621bf1b6cdd8b0e9e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "599b8b1949126487b1c24443b6dd8eb2842eac3884b0e0b3f2d19f5209762a4d"
    sha256 cellar: :any,                 arm64_big_sur:  "fd420b38b733615029bad30f1fdd1f8eadd8dc7530617e6d101fcf0f08d1dd78"
    sha256 cellar: :any,                 monterey:       "aad0354292aa298b7c318dd7b08a09fc60ec153d71a7f60c0d92174f6df3dae1"
    sha256 cellar: :any,                 big_sur:        "52b3c86c85fe3ec3af6581bc23a89416354c75457f01a26b6a1cc5f853d4f1cf"
    sha256 cellar: :any,                 catalina:       "0e1b99075c6656336f906821bf8dfdf2b7610f2182cd7fc901608f02590b74e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452ff2184c01bbea45b034d71799f3575ea0858b5427c71554ca8360832f1f64"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  # Fix detection of Python 3.10 version string. We use Arch Linux's configure
  # patch to avoid having to regenerate with autoconf. There is an open upstream
  # PR for m4 and configure.ac changes, but it is still pending review.
  # Ref: https://dev.gnupg.org/D546
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-packages/6a4d7746de4670dbd245e1855584f7bb5ae10934/trunk/python310.patch"
    sha256 "5de2f6bcb6b30642d0cbc3fbd86803c9460d732f44a526f44cedee8bb78d291a"
  end

  def install
    python = "python3.10"
    ENV["PYTHON"] = python
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when distutils is no longer used. Related PR: https://dev.gnupg.org/D545
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "lang/python/Makefile.in",
              /^\s*install\s*\\\n\s*--prefix "\$\(DESTDIR\)\$\(prefix\)"/,
              "\\0 --install-lib=#{prefix/Language::Python.site_packages(python)}"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
