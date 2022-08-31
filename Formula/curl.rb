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
    sha256 cellar: :any,                 arm64_monterey: "00b2bfb12b8fd68992872941d19f8c38971cfb7f6c34fe72ebb014b8110ebc07"
    sha256 cellar: :any,                 arm64_big_sur:  "bfe2e627bbc57300b521aa008baeedf3da854dbc9189232839786102c0666bc2"
    sha256 cellar: :any,                 monterey:       "17fc00c4141f772fd4d3bf8b11a699a92e2c333ab1b5af881f747c95ed7a566d"
    sha256 cellar: :any,                 big_sur:        "dfa8a24a169a856879e531fc70b91d05b31e0e330134dd92c82f0bffa77eb95f"
    sha256 cellar: :any,                 catalina:       "b014d8a1951cedb87b3d1887d0c9cebe932be7d30f5705ccdf00a2c2c5c2d682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a61990df5672904e6f5ce492e5466dfc4a0ee1e3115a19b26625354c0fbe117"
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
