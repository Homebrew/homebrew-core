class CurlLibressl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.71.1.tar.bz2"
  sha256 "9d52a4d80554f9b0d460ea2be5d7be99897a1a9f681ffafe739169afd6b4f224"
  license "curl"

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :shadowed_by_macos, "macOS provides curl"

  depends_on "pkg-config" => :build
  depends_on "libressl"
  depends_on "nghttp2-libressl"

  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    libressl = Formula["libressl"]
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-tls-srp
      --enable-hidden-symbols
      --enable-threaded-resolver
      --prefix=#{prefix}
      --with-ca-bundle=#{libressl.pkgetc}/cert.pem
      --with-ca-path=#{libressl.pkgetc}/certs
      --with-default-ssl-backend=openssl
      --with-gssapi
      --with-secure-transport
      --with-ssl=#{libressl.opt_prefix}
      --without-brotli
      --without-libidn2
      --without-libpsl
      --without-librtmp
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
