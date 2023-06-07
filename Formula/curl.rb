class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.1.2.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_1_2/curl-8.1.2.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.1.2.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.1.2.tar.bz2"
  sha256 "b54974d32fd610acace92e3df1f643144015ac65847f0a041fdc17db6f43f243"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98f19a2478157214cf70a9464d053f4d3cbb584b9674ca0caa0f6a498427b5e2"
    sha256 cellar: :any,                 arm64_monterey: "53b672721b3bd01810249d8c1fc38d81be55919a5cdc5aeae47a5270f727ae5a"
    sha256 cellar: :any,                 arm64_big_sur:  "7578d993a314c082bc2d41e38a94f717c6fc8e651114382a023a9ee9c4cc7788"
    sha256 cellar: :any,                 ventura:        "fc1fddfaadaa7ee02e512a066be385cf4ae9a2b97d6bdfcf7f022dd58354c76b"
    sha256 cellar: :any,                 monterey:       "83f545ac579a8252bc425774a50d0ad3030e86c0493c070fc9147ae9b3cfbeb0"
    sha256 cellar: :any,                 big_sur:        "6df6d9bdfdcf0e13fe715a0b1828f621ed9291b0a7b5f6274c2edb81070f1761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880183e3784201ce34a77374785a83ba39599e91dffe1a54c183d524bf79ed51"
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
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    assert_match tag_name, stable.mirrors.grep(/github\.com/).first,
                 "Tag name #{tag_name} is not found in the GitHub mirror " \
                 "URL! Please make sure the URL is correct"

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
