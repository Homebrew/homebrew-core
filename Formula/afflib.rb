class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.14.tar.gz"
  sha256 "2d09340e94a72e0d62c6fdc92d6d86a70770229bee5719caca83b532638864a1"

  bottle do
    cellar :any
    sha256 "26f676d4afb7ef30a36b72af253aa6dc04bcafbc37682057c3e3922766ac4b55" => :sierra
    sha256 "723ac0e170f6ec96da14869c54ca7260c50a7bf28334c88371a171a355226f75" => :el_capitan
    sha256 "dd8f5e6ffcc205bd1ae5076d8d790ee546369cba74069f6cc3313ab028ecc456" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :osxfuse => :optional

  def install
    # use Language::Python.setup_install_args instead
    inreplace ["Makefile.am", "pyaff/Makefile.am"], "if HAVE_PYTHON",
                                                    "if HAVE_PYTHON\nelse"

    args = ["--enable-s3", "--enable-python"]

    if build.with? "osxfuse"
      ENV.append "CPPFLAGS", "-I/usr/local/include/osxfuse"
      ENV.append "LDFLAGS", "-L/usr/local/lib"
      args << "--enable-fuse"
    else
      args << "--disable-fuse"
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"

    cd "pyaff" do
      ENV.prepend "CPPFLAGS", "-I#{include}"
      ENV.prepend "LDFLAGS", "-L#{lib}"
      ENV["PYTHONPATH"] = lib/"python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
