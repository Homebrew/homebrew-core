class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.60.tar.bz2"
  sha256 "a8796ecc4fa6c38aad6139d9515dc8113023a82e9d787e5a5fb5fa1b05516f21"
  head "https://svn.nmap.org/nmap/"

  bottle do
    rebuild 1
    sha256 "8f58610988842cc3bafb759036bccb11e091faa83bf8a869367f8897d261d7f0" => :high_sierra
    sha256 "9198abc8f2cb4346023da5f28f6415dddf72494f3453993ae9aec2e9c1fad612" => :sierra
    sha256 "ecfd377136923505c5962c45d5c1383b76fb603590e1d4042d71c9ff8121d5fd" => :el_capitan
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

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
