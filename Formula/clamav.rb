class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.102.3.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.102.3.tar.gz"
  sha256 "ed3050c4569989ee7ab54c7b87246b41ed808259632849be0706467442dc0693"
  revision 1

  bottle do
    sha256 "14f69086a768c2a4a30fd5c4316201363b5265eb4a303159fd7773bc44d42e05" => :catalina
    sha256 "1de7b34afbff07514302deb8ea6f3fb79095509911be98e3ab4f5d674f0f8ef2" => :mojave
    sha256 "7d2140eef1f3af64ec2dc22c78d4a8f1778f56eb9ae84ee3a38fa1814d70d98a" => :high_sierra
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
      --with-llvm=no
      --with-libiconv-prefix=#{Formula["libiconv"].opt_prefix}
      --with-iconv=#{Formula["libiconv"].opt_prefix}
      --with-libjson=#{Formula["json-c"].opt_prefix}
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
