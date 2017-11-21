class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "http://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.3.0/gdnsd-2.3.0.tar.xz"
  sha256 "376f9784c2d6872e0f6e14ab255ca58829f396b436d9c9c846831ee2397f2dd6"

  bottle do
    sha256 "bef99d76ac59572c2f15d516c35815f62348c1287e578c6c02a37abefb4af6b6" => :high_sierra
    sha256 "609e16a1a067d94f0b492465b3bc23c6c77f350bd3d5f11c6425fcd950855f90" => :sierra
    sha256 "849263f34b81cfebc8c0f681a7c4454fbaf2c0e70f44dd2e9ae9f2ffda8e0aef" => :el_capitan
    sha256 "438cd01e0e0e06b9f8bb1a08c43403fbeb66d36a95040f38e67342f9e516ca48" => :yosemite
    sha256 "46e4242acb05972cd999f1b4b981004f1c9d52d5af483be15d17354eb9437a67" => :mavericks
  end

  head do
    url "https://github.com/gdnsd/gdnsd.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libev"
  depends_on "ragel"
  depends_on "libunwind-headers" => :recommended

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
