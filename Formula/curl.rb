class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.74.0.tar.bz2"
  sha256 "0f4d63e6681636539dc88fa8e929f934cd3a840c46e0bf28c73be11e521b77a5"
  license "curl"

  livecheck do
    url "https://curl.haxx.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 "4e85f5e083888ddb215cc7cb445748b5a35baf1853214b2d9ef11ba2c1cc89e0" => :big_sur
    sha256 "35edb3fd3ce31448b290ce441d43235d004e36de4b8f299e8a5c2e2b5118b7fe" => :catalina
    sha256 "36496011f345bd36b4ca83aca7bca3efbc5d30da0b7b039ab847b64aca5ca48d" => :mojave
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
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    openssl = Formula["openssl@1.1"]
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ssl=#{openssl.opt_prefix}
      --with-ca-bundle=#{openssl.pkgetc}/cert.pem
      --with-ca-path=#{openssl.pkgetc}/certs
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --without-libpsl
      --enable-hsts
    ]

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
