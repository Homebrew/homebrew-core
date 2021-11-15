class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.80.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_80_0/curl-7.80.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.80.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.80.0.tar.bz2"
  sha256 "dd0d150e49cd950aff35e16b628edf04927f0289df42883750cf952bb858189c"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f94f33930219bcc493263d2bdcfc414a35785f138f97d62795380e35fbacc30"
    sha256 cellar: :any,                 arm64_big_sur:  "11d8378566d2f9cddfc3e6306d722f7fb311075d93caa201abbb5b4e28ef161e"
    sha256 cellar: :any,                 monterey:       "d67815dec700ffae985fec37be2ec396d6b6eb8e1290acfb8889676722fbbcdb"
    sha256 cellar: :any,                 big_sur:        "e0f327c92e695e92bb13f6c1fd564b7ae4095c1b903d70da84ab2186ebe4cf49"
    sha256 cellar: :any,                 catalina:       "b52ae2384ef3b51de09bb955ef9ea28e73e8eff7c00d57c3aa58a402943147db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3854b26c08652d6db2a4ea26812e067772a9e2206123addf64eb1678572a8f5b"
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
