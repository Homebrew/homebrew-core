class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.15.tar.gz"
  sha256 "cc705a3b4108594fe36f1d843f4a7c60c93fe79375fda3018c21f5cd24949f1c"

  bottle do
    cellar :any
    sha256 "bf7099e77e5fe45903232b2626c90fe56dd67e5e665b0ecf419f00a5ec74161f" => :sierra
    sha256 "ab4128790c08a5b0046c1040b2496311d794ea6406d2c961de320adce71eed94" => :el_capitan
    sha256 "00e6320c5430ed9c03c4c5b843e494536c260fdefbe740f2a1c31d992a6f4f69" => :yosemite
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
