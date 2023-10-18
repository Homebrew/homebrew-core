class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.20.tar.gz"
  sha256 "7264d705ff53185f0847c69abdfce072779c0b907257e087a6372c7608108f65"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "645ea2880c23e3613925a61a769d6df03d272f14d398ed5b38250e1ff17178ef"
    sha256 cellar: :any,                 arm64_ventura:  "39944f02e04efff99d4ba079e10d0e396dfb6025a7129591be8bd69fe194174f"
    sha256 cellar: :any,                 arm64_monterey: "feb3ea9b5e4778eec142cf4d229d49cfc727d9579c5b432fbb3cbce28ce4bce1"
    sha256 cellar: :any,                 sonoma:         "16a7055a8cc8d4ffab10cf59613d06dd26b7e79b70c029bbb60d0cbebdd8e926"
    sha256 cellar: :any,                 ventura:        "4fe2379aa5371898278a70039518c72579e5d19758bcc0dcccc446044a01e703"
    sha256 cellar: :any,                 monterey:       "8970905f67c00de1d7598feec1bd05ccc8db924f1cb267a570530a63ee4fe60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8743cca0396f102a6a57ae731d00b9974e990442101444bccab41c669afe37a5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libcython" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def python3
    which("python3.12")
  end

  def install
    # Fix build with Python 3.12 by regenerating cythonized file.
    (buildpath/"pyaff/pyaff.c").unlink
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

    ENV["PYTHON"] = python3
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--enable-s3",
                          "--enable-python",
                          "--disable-fuse"

    # Prevent installation into HOMEBREW_PREFIX.
    inreplace "pyaff/Makefile", "--single-version-externally-managed",
                                "--install-lib=#{prefix/site_packages} \\0"
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
    system python3, "-c", "import pyaff"
  end
end
