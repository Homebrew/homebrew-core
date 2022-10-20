class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.85.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_84_0/curl-7.85.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.85.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.85.0.tar.bz2"
  sha256 "21a7e83628ee96164ac2b36ff6bf99d467c7b0b621c1f7e317d8f0d96011539c"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3dc6972b2f75130b3a9dc053a5fd277f18576c577b6f0053b9daefb9ba950b4e"
    sha256 cellar: :any,                 arm64_big_sur:  "64419ca6486705f31f43fbf8ab813e6b85c9d836eeadc1229e720f4bc8cd3efe"
    sha256 cellar: :any,                 monterey:       "3aa7c14fefd1953775e8d8a04daa85aaefe23f1b203a1c06dada2ea5a5651de4"
    sha256 cellar: :any,                 big_sur:        "a98877da21bb8b87140022d501eda212ee4e86179d9554e951c2a7ba5e0c78c3"
    sha256 cellar: :any,                 catalina:       "cd3475ba674b19428755722d4d447fceb3ef963779c645b7ddaa6ebb1868819a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70821b581c24e08df332b0e244773044b344a980c255abf5f44b07883b5cb0f1"
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
