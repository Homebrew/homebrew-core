class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.81.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_80_0/curl-7.81.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.81.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.81.0.tar.bz2"
  sha256 "1e7a38d7018ec060f1f16df839854f0889e94e122c4cfa5d3a37c2dc56f1e258"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebc127b7deba2fa4ecb2fd084ca2a77896917489c1f0f267541293611933f156"
    sha256 cellar: :any,                 arm64_big_sur:  "87953b899cb953cf39ef8d3827a7c7e09d81183c7bf7437810c30e281abd02f0"
    sha256 cellar: :any,                 monterey:       "09eceb07be36e526ed08c0fdae0fdac799466828a4a84afd2df79afde20a0f30"
    sha256 cellar: :any,                 big_sur:        "fcfc53d0117e56105009fd8609ccbc9dc6472c56c0e6cf59f1f13ab7e4dc08ff"
    sha256 cellar: :any,                 catalina:       "665bb69230d188c36248a2c493ced5eb2610bd62b9566160e93e2aa7895859bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38adc63685eee2196aed86d79f0c8274184bb28015452430ba12e7a1d4fee93"
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
