class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "https://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.4.0/gdnsd-2.4.0.tar.xz"
  sha256 "3d56ccbb27054dc155839d94df136d760ac361abe868aa6a8c3dbfc9e464bb99"

  bottle do
    sha256 "a61eb7f1440472c102c5e4ee4f5b43945a173ff5e22640b41934205e90c8b6ce" => :mojave
    sha256 "bf4053d2306f90916017cfd77f306268bf19937df83e49766159b081a3583fa2" => :high_sierra
    sha256 "ad45aa5508ea114581c2f3c6476b5be424fe78451ca717464d5555c5bbbe4cb2" => :sierra
    sha256 "e5fdb09670335c84e9223a7170613b565b8dc46ca4629dec994c83a3beda768b" => :el_capitan
  end

  head do
    url "https://github.com/gdnsd/gdnsd.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libev"
  depends_on "libunwind-headers"
  depends_on "ragel"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-rundir=#{var}/run",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--without-urcu"
    system "make", "install"
  end

  test do
    (testpath/"config").write("options => { listen => [ 127.0.0.1 ] }")
    system "#{sbin}/gdnsd", "-c", testpath, "checkconf"
  end
end
