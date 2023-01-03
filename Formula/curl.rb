class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.87.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_84_0/curl-7.87.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.87.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.87.0.tar.bz2"
  sha256 "5d6e128761b7110946d1276aff6f0f266f2b726f5e619f7e0a057a474155f307"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe0cb294a13b62cdf031f9a33e5c41dc44726a5a6e7c473d615769b42f162aff"
    sha256 cellar: :any,                 arm64_monterey: "bb61fd89bf7b336f05192f505520dfddc6459e303fbd2685a690594a92d80240"
    sha256 cellar: :any,                 arm64_big_sur:  "47882084f55244d05faec7e1a526c4046ea712e467af105739456929cd52c5e0"
    sha256 cellar: :any,                 ventura:        "024436c8f9289be56f65a023d989dbc9925832da7487bc2ea9e85c5edcf0ad46"
    sha256 cellar: :any,                 monterey:       "2fd90860e86005f871b2c86d8ec1a9151a49bb79939b8dfbb9416141176575c9"
    sha256 cellar: :any,                 big_sur:        "11e5f63a85e5f40e53bd4cb58419d61b3c716b822df932b2f5e70bbe9c2ead5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6406ab3ded7afe973ce7464262c427d6ef97099fc7916309205401bdf6a828c2"
  end

  head do
    url "https://github.com/curl/curl.git", branch: "master"

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
