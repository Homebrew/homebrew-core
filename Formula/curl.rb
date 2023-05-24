class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-8.1.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_1_1/curl-8.1.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.1.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.1.1.tar.bz2"
  sha256 "51d2af72279913b5d4cab1fe1f38b944cf70904c88bee246b5bd575844e7035a"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7484b9613464857f38753a31290003a8d8b8ab444e9f6a520dc3bc2be269b842"
    sha256 cellar: :any,                 arm64_monterey: "9b4a3bfc39348b956be4762c25a21a9c593206fef92b03ea3824a03e9b70530f"
    sha256 cellar: :any,                 arm64_big_sur:  "8822b0a343dd5e5ce79955d9ab6527d40e48250d93e7cb9d04dd15855d3f136d"
    sha256 cellar: :any,                 ventura:        "7bde9436c3f2edbdda7b86ce171fbb31dbe61d5427827cc867b49b5b5d3ebecd"
    sha256 cellar: :any,                 monterey:       "f48f208ffe2fc3aa805e7b01199b35f03fa08d57cd98cfb432f42f3d640cce8b"
    sha256 cellar: :any,                 big_sur:        "df40079a93c8dc4ca80bbe3113767e7e815dc799928de819a5a2d0257bc26a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78fd95c09ca594517e9944872b90c0feaa623fd867b5b924895f821eb80998dc"
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
