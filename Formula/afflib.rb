class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.20.tar.gz"
  sha256 "7264d705ff53185f0847c69abdfce072779c0b907257e087a6372c7608108f65"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "025c582f57102d59d8db4620a5107ec9f32b9ef260f8ad86ac507e175a240ccc"
    sha256 cellar: :any,                 arm64_monterey: "b2b40e3adb07e9e900d388fd9bca24b40a9c53b9f78212fc6453b7bf220b61ea"
    sha256 cellar: :any,                 arm64_big_sur:  "3c0ea59617618dcac80354ca75cd901e5d938fd29419105a491d72d0dc455d2c"
    sha256 cellar: :any,                 ventura:        "6743bd1cf85500b947f145553c8b6c79c618a4f6e76c56d472874d20d7ace8be"
    sha256 cellar: :any,                 monterey:       "16198534f0890d68d6bd0b311f7078d4b9075cabc578c1ed379c3b95cea81126"
    sha256 cellar: :any,                 big_sur:        "38d2a76e3811b6d244c35521c858f17071f1ce6c9ba9725bb6a2c5125b6d3c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e314fc4730bd8cd0beadab1a6b2c8bc1745ec24d9ce4cad4d13d72427d307455"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libcython" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def python3
    which("python3.11")
  end

  def install
    # Fix build with Python 3.11 by regenerating cythonized file.
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
