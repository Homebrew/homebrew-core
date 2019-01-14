class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.17.tar.gz"
  sha256 "3c5a718731c90a75a1134796ab9de9a0156f6b3a8d1dec4f532e161b94bdaff4"
  revision 1

  bottle do
    cellar :any
    sha256 "7d170683baf0b8e3ae8044e000a3112b6106ca2a32e67ab589610554cf0271bd" => :mojave
    sha256 "b8af707ea41b988e8955160dfac972cf734e20e691606ee9d444fbf1c710cc0e" => :high_sierra
    sha256 "dc5f79c96328f90e9335df61ef1e82236a5ac2bc1015e327d3157b20fa03608d" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  # Python 3 error filed upstream: https://github.com/sshock/AFFLIBv3/issues/35
  depends_on "python@2" # does not support Python 3
  depends_on :osxfuse => :optional

  def install
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
