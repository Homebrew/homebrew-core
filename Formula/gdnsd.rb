class Gdnsd < Formula
  desc "Authoritative-only DNS server"
  homepage "http://gdnsd.org/"
  url "https://github.com/gdnsd/gdnsd/releases/download/v2.3.0/gdnsd-2.3.0.tar.xz"
  sha256 "376f9784c2d6872e0f6e14ab255ca58829f396b436d9c9c846831ee2397f2dd6"

  bottle do
    sha256 "daf899fbc641f2706adc7331f52914640608eecb0d9ce73a35dc46ad9971fe6e" => :high_sierra
    sha256 "aa47b8750157ca483e2df58a8242d2a2a25e59993490d0d039ef750db1a10be5" => :sierra
    sha256 "46f59cea0ac87e5db7ad8b62531ae5ed1b81e1f0f2a4ea93d5e60ff2431b4ac5" => :el_capitan
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
