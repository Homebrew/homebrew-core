class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.16.tar.gz"
  sha256 "9c0522941a24a3aafa027e510c6add5ca9f4defd2d859da3e0b536ad11b6bf72"

  bottle do
    cellar :any
    sha256 "7a5a2cdf54e81089aeda288185c13dd947af90dab3c32f5ce3017d5251f8ea28" => :high_sierra
    sha256 "0a69dea1576c68720739308a0aa66e83c24de8e6b88303f0d3fe371db2f932d4" => :sierra
    sha256 "923868f49a8245403e9e2207780d3a9234e29ea12d9861a671fe5675e1fea046" => :el_capitan
    sha256 "bbebd8159a1a187405374c9fd34a9fad999c44c9c4af60d7c763b97f99f95ae6" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python" if MacOS.version <= :snow_leopard
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
