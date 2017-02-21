class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.40.tar.bz2"
  sha256 "9e14665fffd054554d129d62c13ad95a7b5c7a046daa2290501909e65f4d3188"
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "a8a43b57a4ed84ba718e7ab64015d118d8a9f4b99309ab114edcb8587c2f1693" => :sierra
    sha256 "bf50768abbdcab2554e06925be69321cc6f8d36ed6125bacb6cd25b1af78356f" => :el_capitan
    sha256 "713767f307d9cc28e40cacfe1663c175ec96fa5db483121df996aad1490773a6" => :yosemite
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
