class CurlOpenssl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  revision 1

  stable do
    url "https://curl.haxx.se/download/curl-7.69.0.tar.bz2"
    sha256 "668d451108a7316cff040b23c79bc766e7ed84122074e44f662b8982f2e76739"

    # The below three patches all fix critical bugs. Remove them with curl 7.69.1.
    patch do
      url "https://github.com/curl/curl/commit/8aa04e9a24932b830bc5eaf6838dea5a3329341e.patch?full_index=1"
      sha256 "77595ec475e692bd24832e0e6e98de5d68a43bf7199c632ae0443fcb932791fb"
    end

    patch do
      url "https://github.com/curl/curl/commit/e040146f22608fd92c44be2447a6505141a8a867.patch?full_index=1"
      sha256 "f4267c146592067e84eacb62cdb22e0a35636699a8237470ccaf27d68cb17a86"
    end

    patch do
      url "https://github.com/curl/curl/commit/64258bd0aa6ad23195f6be32e6febf7439ab7984.patch?full_index=1"
      sha256 "afeb69e09b3402926acd40d76f6b28d9790ac1f1e080f4eb3f2500d5aaf46971"
    end
  end

  bottle do
    sha256 "e2f3d69c79e245ec7f7b3c71d9eaa313e90268f96566f6d02496bca99b6184b3" => :catalina
    sha256 "16d894c7a62dd35a41d5f3b12467665429fade2d2bf33be4884b3c7a482bfb48" => :mojave
    sha256 "cac2d3862fe8b42a9c565823398f3899f349e66aa909431da2340e12a626ec56" => :high_sierra
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
  depends_on "c-ares"
  depends_on "libidn"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-ares=#{Formula["c-ares"].opt_prefix}
      --with-ca-bundle=#{etc}/openssl@1.1/cert.pem
      --with-ca-path=#{etc}/openssl@1.1/certs
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
