class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.21.0.tar.bz2"
  sha256 "416e174e165734d84806253f8c96bda2993fd07f258c3aad5f053a6efd463e88"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7932c628062f36ea88ec3587edbcfae7f6cd01adf7a0ea5ba2dbb502d48fb042"
    sha256 cellar: :any,                 arm64_monterey: "c794d10dc455bf42e37efdec1fd60ffb060d3286ac9aac29a264c903ec3e7ffb"
    sha256 cellar: :any,                 arm64_big_sur:  "f94664f483167421ebddf2720bc4f0ba8d39446bb9923ff00e9a8f0eefe593e1"
    sha256 cellar: :any,                 ventura:        "9f93a6b94588f910828fb835c030281f6fcec876884d7b610d530d29aa506730"
    sha256 cellar: :any,                 monterey:       "56e05f923984a175ac612183343fc62975c280b5c340bb2ab9940166d264ef5b"
    sha256 cellar: :any,                 big_sur:        "97fff6e1779100a00f28eba4113ba402eba111d5a99684380201edbd458c3a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cce228e88243a8a271a62d06998e66d69cda8a00dbc29cb3b45095758cdf463"
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
