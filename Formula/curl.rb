class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.77.0.tar.bz2"
  sha256 "6c0c28868cb82593859fc43b9c8fdb769314c855c05cf1b56b023acf855df8ea"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2316dfc6029283ebecf305d4dec3f768300b5073e0829a73c68d1fe05ab416ba"
    sha256 cellar: :any, big_sur:       "45a306b83e606386e74797c4e1ed94437c1941c050e564a98eaf53fdb85ae69c"
    sha256 cellar: :any, catalina:      "57e21718ba4438ece25a46bd5322b48ec277c224683758910bcfa5d348c5750a"
    sha256 cellar: :any, mojave:        "0b735c1d95f0519efa80d375a8f4b39162250a13d2ce592209889ecc7820aca7"
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
      --with-gssapi
      --with-libidn2
      --with-librtmp
      --with-libssh2
      --without-libpsl
    ]

    on_macos do
      args << "--with-gssapi"
    end

    on_linux do
      args << "--with-gssapi=#{Formula["krb5"].opt_prefix}"
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
