class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.11.0/inadyn-2.11.0.tar.xz"
  sha256 "9c8b2a425acb9681564e9fc25a319f2109c7d2ebe1ffe99b06d4a722efb6ecba"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 arm64_ventura:  "698ac07a4d325652848e18f45a209fd5ae07bcf02ffed533183d2ae466ef2150"
    sha256 arm64_monterey: "5e45cd2280d8920b15fce3d5825fba0f705506fc430e8b65d0cdec466c1805a2"
    sha256 arm64_big_sur:  "f9c7ff2d284b203e63793ee34fc56a171acdc99e7ccbb893e4fc7ce5c3624c33"
    sha256 ventura:        "7853e374a5991661db97cc58e9e6c5d37b76308c0e99cd1f093c88ac980ef836"
    sha256 monterey:       "b884d4ccafd28876a4bb6ff25aa6db00dc15dd7f87a77163a53393d8bf17d123"
    sha256 big_sur:        "97e02510700ff61ca2b0932273d15e03159cf01a38df843350868ba4cda095cc"
    sha256 x86_64_linux:   "dd28084bcb90b80a67470ae446b87acfb980ae49228abb6a5a422085684ddaff"
  end

  head do
    url "https://github.com/troglobit/inadyn.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "gnutls"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system sbin/"inadyn", "--check-config", "--config=#{doc}/examples/inadyn.conf"
  end
end
