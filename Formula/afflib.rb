class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.16.tar.gz"
  sha256 "9c0522941a24a3aafa027e510c6add5ca9f4defd2d859da3e0b536ad11b6bf72"

  bottle do
    cellar :any
    sha256 "84aefa7e2449d8162aca396921a568c556f2191db72fd5f03ee2daf6cf9485bd" => :sierra
    sha256 "2efac098c764845cae4a33c4788fd2f811a6a62a9345e4dcdebe4097cd1e09f3" => :el_capitan
    sha256 "7a70c24489fcd92a6f3845dd945eb0822d4018ef937747c720522a1e70e90fdb" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
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
