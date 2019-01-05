class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.100.2.tar.gz"
  sha256 "4a2e4f0cd41e62adb5a713b4a1857c49145cd09a69957e6d946ecad575206dd6"
  revision 1

  bottle do
    sha256 "3c3cf0708c41acea618c1fa44514860e2f628525fff24b32bf7d9b889b0eae6d" => :mojave
    sha256 "b32daa605ce566aeee7f8f6f69bc4b38f4ee5500284f74111eedefb22bfffc02" => :high_sierra
    sha256 "23f15b3fd6bb54d16ca0d12c070160d42d7683a619045a1488049e410f279e8c" => :sierra
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "yara"

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --enable-llvm=no
      --with-libjson=#{Formula["json-c"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-pcre=#{Formula["pcre"].opt_prefix}
    ]

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
