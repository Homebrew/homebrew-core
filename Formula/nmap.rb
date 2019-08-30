class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.80.tar.bz2"
  sha256 "fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa"
  revision 1
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "bc12b9340cf3c23ac9f5a4eb6102884baf556b2347f46c3971600b91fb081125" => :mojave
    sha256 "3cbc937428a7db08be8fa106b3a70ffad16f4a4d80808d2113490dd9ab60786c" => :high_sierra
    sha256 "afa1fde2e44927ccb36447a0ce1dde08927ae67fd789afeb3883a95bd61edbc4" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
