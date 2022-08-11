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
    sha256 cellar: :any,                 arm64_monterey: "5c3c3b5cc635574cec5670ecd56c7c3f7fb209b07feac5d06ed15ae27eabde35"
    sha256 cellar: :any,                 arm64_big_sur:  "a1a1ff0f3fcd571c3a33f3d2498a94784cdcc42d34ebce0210d7d2bac7a47f8c"
    sha256 cellar: :any,                 monterey:       "15d0bb6dc60e5b5625e7dfab00f298049b44f64fea848bae947d38db0819509a"
    sha256 cellar: :any,                 big_sur:        "9a1e47bde50a16222dd2844af84f61fac80caf2db6af0682c05b41bd01948cec"
    sha256 cellar: :any,                 catalina:       "73ee81d3ec9fafdc4568b2f32b2290072ee304df497ff92df2da69bcce75c068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6ea6f488a90c3921d2ceef44c22c6c138e5aa61fb59f66c8326b54ca3083ca"
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
