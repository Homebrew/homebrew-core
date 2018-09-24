class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.100.1.tar.gz"
  sha256 "84e026655152247de7237184ee13003701c40be030dd68e0316111049f58a59f"

  bottle do
    sha256 "01d73f961206740c56c70f0682750afce0a8e58c0c1d746f5bf835a920b5c3f2" => :high_sierra
    sha256 "70dbccd41202356227aed9f9a0bf0f71267170e49ed65027f4b7675af9ccb2a1" => :sierra
    sha256 "221ea32abe28214329b3fb04c4501f21782de5053e9f38badcfbdacde2643fd4" => :el_capitan
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pcre"
  depends_on "json-c" => :optional
  depends_on "yara" => :optional

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-pcre=#{Formula["pcre"].opt_prefix}
      --disable-zlib-vcheck
      --enable-llvm=no
    ]

    args << (build.with?("json-c") ? "--with-libjson=#{Formula["json-c"].opt_prefix}" : "--without-libjson")
    args << "--disable-yara" if build.without? "yara"
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
