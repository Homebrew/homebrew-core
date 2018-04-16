class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.100.0.tar.gz"
  sha256 "c5c5edaf75a3c53ac0f271148fd6447310bce53f448ec7e6205124a25918f65c"
  revision 1

  bottle do
    sha256 "b2a3015190e2f9d51f79315a543943ce14a1fb8fbfd026327c4f58e230df38fd" => :high_sierra
    sha256 "7dad5ab68be23b33f4e9e2bb70c76a91e9dd1e3f67edce47a69565e26ab27012" => :sierra
    sha256 "931b1e3882e520a5a6604b2cd456bc4210d81d4cdb88e9bbc9dfb7644cd08f23" => :el_capitan
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre" => :recommended
  depends_on "yara" => :optional
  depends_on "json-c" => :optional

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --enable-llvm=no
    ]

    args << (build.with?("json-c") ? "--with-libjson=#{Formula["json-c"].opt_prefix}" : "--without-libjson")
    args << "--with-pcre=#{Formula["pcre"].opt_prefix}" if build.with? "pcre"
    args << "--disable-yara" if build.without? "yara"
    args << "--without-pcre" if build.without? "pcre"
    args << "--with-zlib=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed?

    pkgshare.mkpath
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    To finish installation & run clamav you will need to edit
    the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
