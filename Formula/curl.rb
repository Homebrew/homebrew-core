class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.82.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_82_0/curl-7.82.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.82.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.82.0.tar.bz2"
  sha256 "46d9a0400a33408fd992770b04a44a7434b3036f2e8089ac28b57573d59d371f"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75bfcf647a9262c5bd8bc7574f810a54c3db1ab2684fddc9be4dcfd8daf2706e"
    sha256 cellar: :any,                 arm64_big_sur:  "63e4213d2d76076c2f54fd5e0bd79baacd56047915b08be643127cd69819abca"
    sha256 cellar: :any,                 monterey:       "46cf555fb6503a9f0ed3fe9624098a02db9531ca76fa3ae1934d12c273b55972"
    sha256 cellar: :any,                 big_sur:        "bcdfd8b4ce27031422d41bbbd2236ea81c1f79ddd64bb74d4bbe66755805d286"
    sha256 cellar: :any,                 catalina:       "8c51b0b50434fe1757c6f17dcbaa34024373cb12acfb5af2851b82f671d3890f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13945e90fa78c5baac3a77b5daee126143c452c35e92f9b3f396ef9520aa7608"
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
