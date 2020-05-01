class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.102.2.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.102.2.tar.gz"
  sha256 "89fcdcc0eba329ca84d270df09d2bb89ae55f5024b0c3bddb817512fb2c907d3"
  revision 1

  bottle do
    sha256 "544f511ddd1c68b88a93f017617c968a4e5d34fc6a010af15e047a76c5b16a9f" => :catalina
    sha256 "a92959f8a348642739db5e023e4302809c8272da1bea75336635267e449aacdf" => :mojave
    sha256 "252446ee2509c9653fc9ab160811232d228f9995fcd7d4e9378c128bccd5ecaa" => :high_sierra
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libiconv"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --with-llvm=yes
      --with-system-llvm=no
      --with-libiconv-prefix=#{Formula["libiconv"].opt_prefix}
      --with-iconv=#{Formula["libiconv"].opt_prefix}
      --with-libjson-static=#{Formula["json-c"].opt_prefix}/lib/libjson-c.a
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-pcre=#{Formula["pcre2"].opt_prefix}
      --with-zlib=#{MacOS.sdk_path_if_needed}/usr
      --with-libbz2-prefix=#{MacOS.sdk_path_if_needed}/usr
      --with-xml=#{MacOS.sdk_path_if_needed}/usr
    ]

    pkgshare.mkpath
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
