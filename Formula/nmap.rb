class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.30.tar.bz2"
  sha256 "ba38a042ec67e315d903d28a4976b74999da94c646667c0c63f31e587d6d8d0f"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "2db273dbacd4041ad9bd5aefe457aad9a35efaf3817e3e94caa8f4819465529a" => :sierra
    sha256 "b4abf3d589eb43e5bbd8ae831d75a813eeba2579382528d43ed2b6656625016b" => :el_capitan
    sha256 "f564efc3da6773f39e491e23280c72b1e6e91251db6841377af7450cb64edaaa" => :yosemite
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
