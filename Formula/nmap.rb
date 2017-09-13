class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.60.tar.bz2"
  sha256 "a8796ecc4fa6c38aad6139d9515dc8113023a82e9d787e5a5fb5fa1b05516f21"
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "46496cbfdeaedd22ca3afba6bd2b7dafe3bd79a89b8511bc6c246a6e2cd97cc9" => :sierra
    sha256 "92863122b5f00404f3c19ff0ce1ee2c787d3f9c022adff8f772c30c3f0601f2c" => :el_capitan
    sha256 "4b27984c8b92207b1d3e283a1a423a27d63401a809de5e43083722f62be75e35" => :yosemite
  end

  option "with-pygtk", "Build Zenmap GUI"

  depends_on "openssl"
  depends_on "pygtk" => :optional

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
    ]

    args << "--without-zenmap" if build.without? "pygtk"

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
