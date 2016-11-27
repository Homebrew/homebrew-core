class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.13.tar.gz"
  sha256 "4356bb576eaa0d51651ec9754e8c3948f56e439c6c8b98ec6c23d5bebaae86bc"

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
    inreplace "m4/acinclude.m4",
      "PYTHON_LDFLAGS=\"-L$ac_python_libdir -lpython$ac_python_version\"",
      "PYTHON_LDFLAGS=\"-undefined dynamic_lookup\""

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
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
