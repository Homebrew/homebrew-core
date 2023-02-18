class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.88.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_88_0/curl-7.88.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.88.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.88.0.tar.bz2"
  sha256 "c81f439ed02442f6a9b95836dfb3a98e0c477610ca7b2f4d5aa1fc329543d33f"
  license "curl"
  revision 1

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7b94684fe4ea7770ba19c4315c432040411b80089a2161bea33be2c59b4f914"
    sha256 cellar: :any,                 arm64_monterey: "2332c8172a2633d0069b159737d0d2ee4776b2d401c3ec3db5e904305607bf96"
    sha256 cellar: :any,                 arm64_big_sur:  "e4af774fd65c58b3abfd611fc8769843ee915e51da25669e1f8c6248aa5d41ce"
    sha256 cellar: :any,                 ventura:        "a9354d2e35f2f9d9c74f55545abb3dbbc7f0ece734b648c2fa8eaaeb2c5450b0"
    sha256 cellar: :any,                 monterey:       "ec501fe145fc23c1fd814b5d696c5c52cc6c8401ee07b2750f4868478ad5b9a1"
    sha256 cellar: :any,                 big_sur:        "d5b62541fe469948b659a08d01f5de6c8b2e67bc6b5084034c7ef2778bb2b697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb1e7e69498fc6e579480b427b00a9632987837dc3a2312eeb7b77b4721ec32"
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
