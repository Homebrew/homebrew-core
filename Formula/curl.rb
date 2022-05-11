class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.83.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_82_0/curl-7.83.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.83.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.83.1.tar.bz2"
  sha256 "f539a36fb44a8260ec5d977e4e0dbdd2eee29ed90fcedaa9bc3c9f78a113bff0"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cc54bb61de7e47cc717d2af2ca176970b1de34b4c754057e50e25ecd307cdb86"
    sha256 cellar: :any,                 arm64_big_sur:  "0bc9bd180f4dafc106b77ea57ef778cfebca98bdc99dce20da8ce7774991cd22"
    sha256 cellar: :any,                 monterey:       "2210b4a5bd0e1d6e45ffb418775acad0c2c6d0c6a64f11d3e3065ea2b8b28b64"
    sha256 cellar: :any,                 big_sur:        "4013cc1a0992eeb8150d200ca84f9a8dd0968e768f570a0f0b9a00f8f29f4a8f"
    sha256 cellar: :any,                 catalina:       "da65273144f2aef319b786a977893945100475d8580029e6885b006837e1f43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afff7ad1947ae695f1d2dbec29fa283fd9db9daf28159c44d4ba567e3997df9d"
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
