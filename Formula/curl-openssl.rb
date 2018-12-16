class CurlOpenssl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.63.0.tar.bz2"
  sha256 "9bab7ed4ecff77020a312d84cc5fb7eb02d58419d218f267477a724a17fd8dd8"

  bottle do
    sha256 "84c070944750b1ab555478769569326a5af985de9242b64a4f59041cd51b4a3b" => :mojave
    sha256 "d3cac8f1bd6593c58358e9e7c3b187182f9b7be5ed1edd4f372c4afb83eea052" => :high_sierra
    sha256 "075a6eb711c03a18bd6a5a39ac537224e2cd3acec447b358015239d925547f72" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl"

  def install
    # Allow to build on Lion, lowering from the upstream setting of 10.8
    ENV.append_to_cflags "-mmacosx-version-min=10.7" if MacOS.version <= :lion

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-ares
      --with-ca-bundle=#{etc}/openssl/cert.pem
      --with-ca-path=#{etc}/openssl/certs
      --with-gssapi
      --without-libidn2
      --without-libmetalink
      --without-librtmp
      --without-libssh2
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
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
