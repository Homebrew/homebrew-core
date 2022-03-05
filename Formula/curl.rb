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
    sha256 cellar: :any,                 arm64_monterey: "a205db46ac75829993701f3c4b1af4db42629d3f8b74c11bda8e3059776bd6a0"
    sha256 cellar: :any,                 arm64_big_sur:  "084bfa547e5f476b1a1868737080a187581957057170d56c15c868c0680e9283"
    sha256 cellar: :any,                 monterey:       "a47f615f634dd25168cb0fa952db5b97419a81fe310cb0aa043427620291e95a"
    sha256 cellar: :any,                 big_sur:        "91c16d0c8df24a416cb8864aec4078f3d969616d1718e158ebfb3b3addc8506b"
    sha256 cellar: :any,                 catalina:       "8ca7e9dd87f61ccdcd3d09793356d92bdc98953ea75c1da25d4cd5f8dd0a52bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382eebd6c8b4d6a298d5636d2a8848140aaec1cf8fd76a8b4c018766c3e22d55"
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
