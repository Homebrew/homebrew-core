class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.20.0.tar.bz2"
  sha256 "25a5785a5da356689001440926b94e967d02e13c49eb7743e35ef0cf22e42750"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d9d41fb09043965efda2748025243994a0457ec2da37afce988d9fe9733aae4"
    sha256 cellar: :any,                 arm64_monterey: "f60a8b787ff8754d7da6a547456c78792df6c8235d0bf57e7466b15c3c387fcd"
    sha256 cellar: :any,                 arm64_big_sur:  "f6eebdfc1790e0179b2be7d90f53fcc2235f39a093ab41ab4928b9bf545cc56b"
    sha256 cellar: :any,                 ventura:        "c1c3454c7d75beb3d28865d2c56684ce5f847dba45d9a6cc934ceb92c81fd126"
    sha256 cellar: :any,                 monterey:       "99ab338b41d3e48743a87b1e8de6ead43d93439e745e7a4a6e428b5fe144e790"
    sha256 cellar: :any,                 big_sur:        "ce65ea6d51cf28a53345a291bb0a765b1b3e3fa96800df3b5cb4462961568d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2ce80404f5a3e01de4000babe8d8edb0a217adef098b79917619ca150fbf7f"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.11"
  end

  def install
    ENV["PYTHON"] = python3
    # HACK: Stop build from ignoring our PYTHON input. As python versions are
    # hardcoded, the Arch Linux patch that changed 3.9 to 3.10 can't detect 3.11
    inreplace "configure", /# Reset everything.*\n\s*unset PYTHON$/, ""

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    site_packages = prefix/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "lang/python/Makefile.in",
              /^\s*install\s*\\\n\s*--prefix "\$\(DESTDIR\)\$\(prefix\)"/,
              "\\0 --install-lib=#{site_packages}"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static"
    system "make"
    system "make", "install"

    # Rename the `easy-install.pth` file to avoid `brew link` conflicts.
    site_packages.install site_packages/"easy-install.pth" => "homebrew-gpgme-#{version}.pth"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
