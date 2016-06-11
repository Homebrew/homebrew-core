class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.99.2.tar.gz"
  sha256 "167bd6a13e05ece326b968fdb539b05c2ffcfef6018a274a10aeda85c2c0027a"

  bottle do
    sha256 "057465d3af56d272c79cb46fafad7d73846cc94af383b73ff91413d8f4ff7039" => :el_capitan
    sha256 "fe1dfc76b755c95c8b89794914f294f9ace4e8e6dacb0dc9a0c02ee0c7648d54" => :yosemite
    sha256 "718d0a2220aab846413edb8ad1b0f56cebc10f035c766ff9cdd8dc63924872b6" => :mavericks
  end

  head do
    url "https://github.com/vrtadmin/clamav-devel.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "yara" => :optional
  depends_on "json-c" => :optional
  depends_on "pcre" => :optional

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --with-zlib=#{MacOS.sdk_path}/usr
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

  def caveats; <<-EOS.undent
    To finish installation & run clamav you will need to edit
    the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
