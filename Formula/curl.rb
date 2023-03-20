class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-8.0.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_0_0/curl-8.0.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.0.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.0.0.tar.bz2"
  sha256 "dd6e792593dbd2253cc2da57265808427e3614e84ca86d424fbc75cf9baba08c"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08848696ddff3fba97be392f5d2bf9943d8b353625f48eb384180803dd0afeb5"
    sha256 cellar: :any,                 arm64_monterey: "2e798ccc193765d4493fa3ee9cc7e168817557b884e74c43869eeff26299769b"
    sha256 cellar: :any,                 arm64_big_sur:  "1e52651a966cdf432d778ab89795a00dfd71d7969ea9477de6b7f080c379f3c4"
    sha256 cellar: :any,                 ventura:        "72d1772795ffdb13b8d77243b1c42dd9b6367ed47cc25edb2bf7c12b684585d3"
    sha256 cellar: :any,                 monterey:       "804a665b827fb444ba98d34b10de4fc2c771de682878a397d6a2d2f18af3ca06"
    sha256 cellar: :any,                 big_sur:        "faddeff20a1d854e5b9a78ea5c7e068db9dd05f3b6f86fed295199bc204fb7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f915f992603842a7f608881e78d696fb9fd288e7fcf0f9f9c2b76fb72c2508e4"
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
