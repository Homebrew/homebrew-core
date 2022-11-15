class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.86.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_84_0/curl-7.86.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.86.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.86.0.tar.bz2"
  sha256 "f5ca69db03eea17fa8705bdfb1a9f58d76a46c9010518109bb38f313137e0a28"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b7a7da687d38bd0af866ac9cfe9742dae6768be3f85ec6818e0aaab7e5a2559"
    sha256 cellar: :any,                 arm64_monterey: "0cdd9eb396948516734173c50c6141e1ad9a903e160f4b23a872f97d0e2002f0"
    sha256 cellar: :any,                 arm64_big_sur:  "045534938a2eb05616f953e9fe4eefebdad68ab4c669b0a178c5345e6ceb882f"
    sha256 cellar: :any,                 ventura:        "cac2c7b368a10971764a97dc09dddb8080753f1c040167345389b48c79399235"
    sha256 cellar: :any,                 monterey:       "db7f89126bfe8e395d66f85c32248aa661c67b3c43239dd3e005e7f0c2207382"
    sha256 cellar: :any,                 big_sur:        "b12dec85a01d31a0df5533eae23faa1bf3eaf5288ff4aa5723492d3ad0a26a37"
    sha256 cellar: :any,                 catalina:       "e47bfdea8a239cff79569297ff9a2d35b528b1f569acefd57a8e1470b7e8d4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a6850f668db26c218ea436d0792f4e26b1951e1ecbcc9d8e820b6fc433ac65"
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-libidn2
      --with-librtmp
      --with-libssh2
      --without-libpsl
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
