class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.102.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.102.0.tar.gz"
  sha256 "48fe188c46c793c2d0cb5c81c106e4690251aff6dc8aa6575dc688343291bee1"

  bottle do
    sha256 "4e78b3649f40ff746343f6593074cca1df281d480323e31e9d08e6cdda77e48a" => :catalina
    sha256 "e0ca454c1ef225dcaf647a3f709819b73b28c66861256159b6718c80098f8a70" => :mojave
    sha256 "887186bdbadcb1c2aec51a4152c8a244b4ee767fd162786f4625d2017fc97d2f" => :high_sierra
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
