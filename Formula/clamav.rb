class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.102.2.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.102.2.tar.gz"
  sha256 "89fcdcc0eba329ca84d270df09d2bb89ae55f5024b0c3bddb817512fb2c907d3"

  bottle do
    sha256 "8240d37b0fa38f3728a57ce6b80e41e437e9501cdb07ea59e42ecc7ade8709d1" => :catalina
    sha256 "ed4be5269f9254ebb369de26cd0f39e57bd66ffcdb708b66e785db1ef083b80a" => :mojave
    sha256 "72ecdcf3473919c7665a099686926b21fe3a9b4b467bd9607d80181d3d1bbc67" => :high_sierra
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
