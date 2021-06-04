class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.103.2.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.103.2.tar.gz"
  sha256 "d4b5d0ac666262e423a326fb54778caa7c69624d6c3f9542895feb8478271bd2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "08f7636b609fddf9d71d654831910e8354096d2352b31eedbe3a8f363c36072c"
    sha256 big_sur:       "fe53693f8f14392597ac7495d80188bdee88455862c830d6ada5613ddbe50084"
    sha256 catalina:      "ad496a6937046968511af7c71bac5514ce35f8c104f1711bb6b2ffe1bde372eb"
    sha256 mojave:        "850cecb7bc17f8a0000e4666a1432b320722712fb394191c6b488c1307c60d0c"
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
