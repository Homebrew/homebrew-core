class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.101.2.tar.gz"
  sha256 "0a12ebdf6ff7a74c0bde2bdc2b55cae33449e6dd953ec90824a9e01291277634"

  bottle do
    sha256 "cbef65f2a166846c4fa9ca587c0fbec377a1097c4ca373dbc516fd3e046c1656" => :mojave
    sha256 "df08e40c3bf58a94a0a69f07ac784204e6a4dcdddabc9523c7a2f2311e0eef84" => :high_sierra
    sha256 "62d29e0ff39529a36c6e513493ffd86136efa5b7561ecec13ca1f06521cae955" => :sierra
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
      --with-zlib=#{MacOS.sdk_path_if_needed}/usr
    ]

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
