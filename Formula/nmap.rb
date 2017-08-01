class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.60.tar.bz2"
  sha256 "a8796ecc4fa6c38aad6139d9515dc8113023a82e9d787e5a5fb5fa1b05516f21"
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "90182a3b912028377b5f140e98fcd72bb35c661c208ebac6ad6e4a11cbbedde5" => :sierra
    sha256 "c0b3713a04029728da283fffc16763ec70e44a5db85c090d7697cae3b37b7216" => :el_capitan
    sha256 "0bd48550d18fa1d7caccebe3e0a40994116e56c8dfb712bad2207dafcd685cf9" => :yosemite
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
