class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.103.0.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.103.0.tar.gz"
  sha256 "32a9745277bfdda80e77ac9ca2f5990897418e9416880f3c31553ca673e80546"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "2d28fcabebc27f3c72a366c8ebce2ed82a86ac56ae4eafd152c251681666752b" => :big_sur
    sha256 "f2620d623d65ebe6c2a10e6b6148b517e7424f4190393b0f8257ac3aeaf77d8d" => :arm64_big_sur
    sha256 "223f07db86b0ed0e4e51db8d634111bb842dcc49c01df6dbe5dedcf46e786e44" => :catalina
    sha256 "8155acb6f0bf2f1fd110612e8eda7ade7845f3fc3310332af6ae182660ab7692" => :mojave
    sha256 "458d060d70d37beb01b924ada3be7474b25f4a4c8a2bfb33f6bfb0251ab19024" => :high_sierra
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
