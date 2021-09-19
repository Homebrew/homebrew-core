class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.79.0.tar.bz2"
  sha256 "d607a677f473f79f96c964100327125a6204a39d835dc00dab7fc0129b959f42"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "716c1bdff59df7c308dae76a32b66b4bb568a6c49d718593c6618d12a2e911f2"
    sha256 cellar: :any,                 big_sur:       "b3fa91eaa148fd67283c97a3cd8f7ae501a62e830cdb4a8d514079dafc31400c"
    sha256 cellar: :any,                 catalina:      "288ceac412ec97d4dad5e80b3c0afe847dab5d7d148a7906478fc13d485ed7af"
    sha256 cellar: :any,                 mojave:        "d1a82b42913a6df82d7fc00018185aa6c74ca24ddeb24fc96702a35004a6723e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8b1a9a79c2c624a2a40a075b140698f7567d36273fd6a0345b303371c321a7"
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
  depends_on "libssh2"
  depends_on "nghttp2"
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
