class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-8.0.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_0_0/curl-8.0.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.0.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.0.1.tar.bz2"
  sha256 "9b6b1e96b748d04b968786b6bdf407aa5c75ab53a3d37c1c8c81cdb736555ccf"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c02384f2793e6ff576ac2e8a282eb0393e1f0dd765d76073d2164ddd17fb7017"
    sha256 cellar: :any,                 arm64_monterey: "c3a3bb6be6bb8c79fa30aeca813c6fc378634e1536f2a2d4436a3d831b8f8f53"
    sha256 cellar: :any,                 arm64_big_sur:  "e6da784b9be59ddac19624bfe131f1f830755a385ef26c0f53b82025bd88162d"
    sha256 cellar: :any,                 ventura:        "6fdf22e7672ebb8a945590f2fcdd1c7a88d9c39c2234a850366e798338bf30b3"
    sha256 cellar: :any,                 monterey:       "876e4e2dbc218475ab6d192b467defdfdc03367c9e7be7640946f821604da312"
    sha256 cellar: :any,                 big_sur:        "ef9f9c774965039cda38f60c01678507a3c9b5b8f0507804565c170025cfc364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7159cd4edaea6cfb3e91b46691d86325a31fa324a4f2d8657b2f72552e92fce7"
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
