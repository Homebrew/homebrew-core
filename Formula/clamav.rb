class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.99.4.tar.gz"
  sha256 "d72ac3273bde8d2e5e28ec9978373ee3ab4529fd868bc3fc4d2d2671228f2461"

  bottle do
    sha256 "d5146acf7afe62f40ceffa44234817d277b1f5ee17971d2be1033c57a8c09637" => :high_sierra
    sha256 "e2f7599ca651902b33941333765154588cf4598601704035dada3d463eb5df7f" => :sierra
    sha256 "8288f881dfe8a42c7adaf566a76d19152f9adda6c01f38e3ca2efa44d1fe3fc6" => :el_capitan
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
