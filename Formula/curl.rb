class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.79.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_79_1/curl-7.79.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.79.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.79.1.tar.bz2"
  sha256 "de62c4ab9a9316393962e8b94777a570bb9f71feb580fb4475e412f2f9387851"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "848ef1fcbd49c13bf4dc0890f6666fef3cedc3eb545be8fbbb4efad168137ee0"
    sha256 cellar: :any,                 big_sur:       "0ecffc9a6220064210b9506cdc34cdf4f118fbed2f51fd6b7fe608c2e42649aa"
    sha256 cellar: :any,                 catalina:      "4ec3be96813a0aabb4489a2a47363490e022d6ed0693fdb917dae666c081582b"
    sha256 cellar: :any,                 mojave:        "484934e11387cc3c72964577f609f701783c7d55add3fa0df03245e3f5e8c590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88caede39c8b0df2aab1e02ab7c8dd8d89859f9321c287d025850b4edc1d3bb5"
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
  depends_on "libssh2"
  depends_on "nghttp2"
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
    libexec.install "lib/mk-ca-bundle.pl"
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
