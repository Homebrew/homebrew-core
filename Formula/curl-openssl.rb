class CurlOpenssl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.72.0.tar.bz2"
  sha256 "ad91970864102a59765e20ce16216efc9d6ad381471f7accceceab7d905703ef"
  license "curl"

  bottle do
    rebuild 1
    sha256 "f8afef570ee8ddb4a8b361ebd106aaf1bab9d79f5982a1e985d2eb5a1ad51cbc" => :catalina
    sha256 "816388345c2f8526917e1b2391880727f5e485a377e4653af870f5adc14f65a8" => :mojave
    sha256 "f6296108ec442e1c32d849b43b1e650039e00dc88d39d82da8a87483c5d0aa80" => :high_sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :shadowed_by_macos, "macOS provides curl"

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "libidn"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"
  depends_on "zstd"

  def install
    system "./buildconf" if build.head?

    openssl = Formula["openssl@1.1"]
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-ares=#{Formula["c-ares"].opt_prefix}
      --with-ca-bundle=#{openssl.pkgetc}/cert.pem
      --with-ca-path=#{openssl.pkgetc}/certs
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --with-ssl=#{openssl.opt_prefix}
      --without-libpsl
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
