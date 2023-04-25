class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-8.0.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_0_1/curl-8.0.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.0.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.0.1.tar.bz2"
  sha256 "9b6b1e96b748d04b968786b6bdf407aa5c75ab53a3d37c1c8c81cdb736555ccf"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2a30c3f61e8bf63d3239c7ee08fa61e93be8fe1809aa24c3fce985fb8356194"
    sha256 cellar: :any,                 arm64_monterey: "6f87b509c3db85c87da2a14b36b37238ab2b0f5f18f58bf4026653f624c30e63"
    sha256 cellar: :any,                 arm64_big_sur:  "8664ada9a7936a8c93b4372c94386db6ed16c3b6143ab8b224a060d72457dca1"
    sha256 cellar: :any,                 ventura:        "29740e457eb7467a0a58f9b5c87fd0d9e579919530f70a171c54d18f8dca88db"
    sha256 cellar: :any,                 monterey:       "5e9cd21254752b8d6285c8a38a62105bacb4177169bd9ebee7f650c754fc3f1b"
    sha256 cellar: :any,                 big_sur:        "2d8a2634af4125b34e6b01dfcc29092811b88b03c5f582af27b944b68577ce9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067f43aabdf654fe22e91be2858641be2c7cd3704d552d06e6c6484e7ecbbb5e"
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
