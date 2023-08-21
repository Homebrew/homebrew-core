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
    sha256 cellar: :any,                 arm64_ventura:  "f70b99a2dcbbe6f02f8e68947a66d5b6135ff312bd68e615a2d563a6024fa762"
    sha256 cellar: :any,                 arm64_monterey: "810fa90bb97749a60f9afb2d641a09e6c7fbe81ce2c43c70a492f2e0b94baa95"
    sha256 cellar: :any,                 arm64_big_sur:  "1883e6f1b7f31b0ec70008ab32333096a354b3a39e149b7477f1f41311956bab"
    sha256 cellar: :any,                 ventura:        "e589fede26d18a7da57dc67da470a821a91753235868504d7c780e569c8a49cd"
    sha256 cellar: :any,                 monterey:       "29e8f49a180d936652393aad1e21f1f2e3f813653c7df91efcf8e5b39d31a625"
    sha256 cellar: :any,                 big_sur:        "aecd70af3a64d7d8bb2f54a4b02066e4e85b292b3b4c83aaa0ebd3ee59231f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264f0c1e8fc945963dc1654e68e6d6b99575fb85ddc3ff2d15b7597ee1a9417e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libcython" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
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
