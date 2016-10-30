class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "http://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.2.4/gdnsd-2.2.4.tar.xz"
  sha256 "ee26ddd11087f4dd617c9aa6bfa3b963c5d883578b49c7d5dcae5d0edf38094f"

  bottle do
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
