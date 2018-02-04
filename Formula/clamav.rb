class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.99.3.tar.gz"
  sha256 "00fa5292a6e00a3a4035b826267748965d5d2c4943d8ff417d740238263e8e84"

  bottle do
    sha256 "5dd832821e5f6d789d18ffc57c06c05921c3c7f3ca49e308fc42d7f4be16df1d" => :high_sierra
    sha256 "e1f1364322120980fd21d14cee0b2b147ddd8defab9195fded3d9473829f68a9" => :sierra
    sha256 "508a85cbff97201447e30bc8952a300d3b2090c48eeddf3d96990c5bcf94b272" => :el_capitan
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

    args << "--with-libjson=#{Formula["json-c"].opt_prefix}" if build.with? "json-c"
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
