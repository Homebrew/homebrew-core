class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.100.1.tar.gz"
  sha256 "84e026655152247de7237184ee13003701c40be030dd68e0316111049f58a59f"

  bottle do
    rebuild 1
    sha256 "b783c48282b431f6a616a41c6e36df75531523910808a96750584490a6aaa611" => :mojave
    sha256 "2e4e3a561a1652ce16cb4810670968e097db1ea87508cc35b40706e26c567c27" => :high_sierra
    sha256 "12b35691fc199071a18ed7e7cd7b05e79a7106164e6dff31356e31ab46bd3814" => :sierra
    sha256 "90ad4d0ddc832c5a96413f877d6967cc4b7c3c67c3ece37a663def3f08b309c3" => :el_capitan
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
