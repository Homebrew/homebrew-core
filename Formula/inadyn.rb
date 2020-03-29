class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.6/inadyn-2.6.tar.xz"
  sha256 "9f4198764abbd2798472b349d8867e86b4692c76ee304f1f9c607f67c9b582a4"

  bottle do
    sha256 "51a4e9ac812bcef5def36bce74489e54bba0e2c671491c738a41c42c6f7c4918" => :catalina
    sha256 "850595bc38129a1301b47e285b826ba578f301ae285a5fbf2239c41334d54bba" => :mojave
    sha256 "863dc8ee816ca82fb165c3919ea9b0fd564648a745e3525d46043318f5c93723" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
