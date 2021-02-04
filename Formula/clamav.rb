class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.103.1.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.103.1.tar.gz"
  sha256 "7308c47b89b268af3b9f36140528927a49ff3e633a9c9c0aac2712d81056e257"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "819a822b63f106657c8e0374eddad592eda5aebaa608a16111578b8e5dac390c"
    sha256 big_sur:       "ef79742b675d0b07d1cef974996a4647848ba2d2508c3f7a011d93090ae52e3a"
    sha256 catalina:      "aeb895673034b67934ec56ab7bc91c49e6034c80c54c699966f2ed6064b0aba8"
    sha256 mojave:        "d5e992c19a4104eea8a8cf17cd13f71e18a0484a35939a30f2aec534603bb5ac"
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
  depends_on "libtool"
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
    ]

    on_macos do
      args << "--with-zlib=#{MacOS.sdk_path_if_needed}/usr"
      args << "--with-libbz2-prefix=#{MacOS.sdk_path_if_needed}/usr"
      args << "--with-xml=#{MacOS.sdk_path_if_needed}/usr"
    end
    on_linux do
      args << "--with-zlib=#{Formula["zlib"].opt_prefix}"
      args << "--with-libbz2-prefix=#{Formula["bzip2"].opt_prefix}"
      args << "--with-xml=#{Formula["libxml2"].opt_prefix}"
      args << "--with-libcurl=#{Formula["curl"].opt_prefix}"
    end

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
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
