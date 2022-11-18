class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "50d62d9c03fd0e7440d660bcb60a85e1b75e9c9249ab9dbb7049729f20d05fa1"
    sha256 cellar: :any,                 arm64_monterey: "3e5919d12d9513c23e82822dd2ffd2947af505ed2f70ef1231e3355abe576faa"
    sha256 cellar: :any,                 arm64_big_sur:  "6dd3ec1e1f3e71c9c57229dd23db7e6cfd7d1ce1ab06834f490597f5ba57ae13"
    sha256 cellar: :any,                 ventura:        "7c9b57955330197f76b579d9f029f9daf80f66a45b3b2af19904d42d2f1e3cf0"
    sha256 cellar: :any,                 monterey:       "b97d1449f77720b8893095c05b07a2a24af9744aaa4a5f120e500bec638ee924"
    sha256 cellar: :any,                 big_sur:        "afe54b17929f33962a429e78e73aff41d8ea7c6c52d0e1a3fcdf41004a3a0de6"
    sha256 cellar: :any,                 catalina:       "d6bececfde0fa878628d15954d4e3300f94be5f50a9e82493c1e96938ca885fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c23676a86073eb745c7437c2ae69de89b0c1672030a8f3c989b440f2b7a292"
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
