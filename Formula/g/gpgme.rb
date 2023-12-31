class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.23.2.tar.bz2"
  sha256 "9499e8b1f33cccb6815527a1bc16049d35a6198a6c5fae0185f2bd561bce5224"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "4b49bf5ea7e69c0c9cb5f13ca94398eb1a30a00e53d5193adb56f0aac5626ec3"
    sha256 cellar: :any,                 arm64_ventura:  "2e549053a2c930e434bdef847fe2e819aef1e5ff7bb09ff9e5e803473f36effe"
    sha256 cellar: :any,                 arm64_monterey: "4836f5e1527f50d698845d99ae67a92e28e302d8d0383d527c930d0e5e157cbc"
    sha256 cellar: :any,                 sonoma:         "442157cb14484e7a8a4a0e83e6ff9f63841f48199d3eaac71ba80a282d41cc29"
    sha256 cellar: :any,                 ventura:        "92aaa37de9c8f4376aa5a8bc21427f968bcf6cb8b971fe1dce805ad1bf31a2fc"
    sha256 cellar: :any,                 monterey:       "47ca2ef9ba26f00419c1494b4213c5555fc7bb6dcad1689f481cc6ccbcd1eeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e1abe69918c83216b4394e4723eb37e19bfb7911fad6c359ea759e573726c8"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.12"
  end

  def install
    ENV["PYTHON"] = python3
    # HACK: Stop build from ignoring our PYTHON input. As python versions are
    # hardcoded, the Arch Linux patch that changed 3.9 to 3.10 can't detect 3.11
    inreplace "configure", /# Reset everything.*\n\s*unset PYTHON$/, ""

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    # Use pip over executing setup.py, which installs a deprecated egg distribution
    # https://dev.gnupg.org/T6784
    inreplace "lang/python/Makefile.in",
              /^\s*\$\$PYTHON setup\.py\s*\\/,
              "$$PYTHON -m pip install --use-pep517 #{std_pip_args.join(" ")} . && : \\"

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
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
