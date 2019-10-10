class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.101.4.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.101.4.tar.gz"
  sha256 "0bf094f0919d158a578421d66bc2569c8c8181233ba162bb51722f98c802bccd"
  revision 1

  bottle do
    sha256 "30723c23def81f1f4a08a60663f516f152ab42fdaf96f8071c4fd93fc559d927" => :catalina
    sha256 "59d485f311b59e93d6ce9fe7b6b3fa1904824477c19e7b88aec15580d0a07243" => :mojave
    sha256 "b80e34e7b4b25dc39c374d99aa8344cdaf0e942ab1607095b921d2600485531a" => :high_sierra
    sha256 "65598589702e4b7c8efe2189f41dc19f9771ce8fe8386440e6923a15235d664c" => :sierra
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
