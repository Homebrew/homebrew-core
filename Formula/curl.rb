class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.79.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_79_1/curl-7.79.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.79.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.79.1.tar.bz2"
  sha256 "de62c4ab9a9316393962e8b94777a570bb9f71feb580fb4475e412f2f9387851"
  license "curl"
  revision 1

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fb8bc11a92e6b9c69415ebcc0ac30a69d5fa7399ed48eda8f39acd08fb030f91"
    sha256 cellar: :any,                 big_sur:       "67eb98cd0d153e0e7ca5aadde8141da15cd6f47990136722e49e4a40b3d53c41"
    sha256 cellar: :any,                 catalina:      "c623592e8eb8cd9c4e60598f58e9e716b7daea398e75f207c23339624b8f4a71"
    sha256 cellar: :any,                 mojave:        "097d1eb078e53456d952030e0186eb153a515044336db22da0d7942eba21a7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730a10df5cd6086457c2ed329b0e881c6a8cd70590f5d7e5e731361438b822c3"
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
