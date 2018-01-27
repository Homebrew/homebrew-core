class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.99.3.tar.gz"
  sha256 "00fa5292a6e00a3a4035b826267748965d5d2c4943d8ff417d740238263e8e84"

  bottle do
    sha256 "804bf3a1e0ad84d78e46fe9e0ed5555fa9a2c3d1e866d312fa9a0f8645baef29" => :high_sierra
    sha256 "a5bc9cce487de2b2d65f536f088343507e7e3b4f6918810624d02a2f21c24a89" => :sierra
    sha256 "0e8fa7cfafc6a8c2fefd2f0c2044d7ef6c7efa3839444609c326c4ed0cf5520f" => :el_capitan
    sha256 "7f0d14eb642997a856796366e8ff6c1b17fb6076aa198d1255c6bf73c0862a33" => :yosemite
    sha256 "6b82bf35cd1cc06cf6f736e69763397ed6225f71217c780ae91ebc30df8f1c70" => :mavericks
  end

  head do
    url "https://github.com/vrtadmin/clamav-devel.git"

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
