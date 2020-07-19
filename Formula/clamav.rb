class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.102.3.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.102.3.tar.gz"
  sha256 "ed3050c4569989ee7ab54c7b87246b41ed808259632849be0706467442dc0693"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 "2bb5ea7de66e798672e5f9a6bb49bb2d0f3f723a655fe365a5f12322567c6ef3" => :catalina
    sha256 "c5dc15e28ffab603fea38b1e22fda3023384ae654544554f40d75038b7cb4318" => :mojave
    sha256 "fd1d05cd3c62e0af9ee1a7b9b875d0f8ce776d4a4022c0fb3b184a806669abb0" => :high_sierra
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
