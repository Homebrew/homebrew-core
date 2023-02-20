class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.88.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_88_0/curl-7.88.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.88.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.88.1.tar.bz2"
  sha256 "8224b45cce12abde039c12dc0711b7ea85b104b9ad534d6e4c5b4e188a61c907"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed6ed15415c8218434557fc7961c4c084c4ce7eb3001f24536e37a49623e2658"
    sha256 cellar: :any,                 arm64_monterey: "82c015b698092a3cfcae1561d5e29c44a430d863e0e36b6a9d85fa60a61a2a08"
    sha256 cellar: :any,                 arm64_big_sur:  "d38d1f46e90161a224364492a52db70973c8fb3cbff831b3ae39515efebf70f7"
    sha256 cellar: :any,                 ventura:        "2337afd14fdd093dcd7a16f976eb4a630579c6185ab34152c6b683244d868f1f"
    sha256 cellar: :any,                 monterey:       "11919d972dc7d875b13e5e8e85388ac4e9f8d85d8e2e1a3d7ed57f51d197f1dd"
    sha256 cellar: :any,                 big_sur:        "550eddbe6f6bcf4dd7410ad4d950dcdf060271cedd4a866658f9a8c463565a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b87c6473f72c9f5c4cb9b9459d164328461452b7253dac330628aa8e34b1a6"
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

  # Fix HTTP/2 corruption issues.
  # Remove with 7.88.1.
  patch do
    url "https://github.com/curl/curl/commit/3103de2053ca8cacf9cdbe78764ba6814481709f.patch?full_index=1"
    sha256 "f4abbeb8174ab51b393da02c2761ba56bc40c577b5802aa41e74a3adc7d5a0be"
  end
  patch do
    url "https://github.com/curl/curl/commit/87ed650d04dc1a6f7944a5d952f7d5b0934a19ac.patch?full_index=1"
    sha256 "39f74a9c88dced544a8ea0a1c1e8c9f30eae19c41223350991ebf03e5dec764d"
  end

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
