class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.31.tar.bz2"
  sha256 "cb9f4e03c0771c709cd47dc8fc6ac3421eadbdd313f0aae52276829290583842"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "575123f2d2010f2cd05988dbf3534c005efe3607d0f0fca1e083369f508348f1" => :sierra
    sha256 "69ccdc8010781ad9e827571259ed18cc605f8271d48ed9a2910f5a48ef212fdc" => :el_capitan
    sha256 "613e3457aabdbd74919b8d16e29fe730141c265b1050233ee778dac76aaa8973" => :yosemite
  end

  option "with-pygtk", "Build Zenmap GUI"

  depends_on "openssl"
  depends_on "pygtk" => :optional

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  fails_with :llvm do
    build 2334
  end

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
