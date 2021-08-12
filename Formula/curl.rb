class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.78.0.tar.bz2"
  sha256 "98530b317dc95ccb324bbe4f834f07bb642fbc393b794ddf3434f246a71ea44a"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5b3ffcee1ea579b665fedfc19841ace3f068f0b065d9362bb093cf6fb30a743e"
    sha256 cellar: :any,                 big_sur:       "875acbe04343e88db8fae96aab1d178b5e71cb39f737dd60472c9f18b7b60129"
    sha256 cellar: :any,                 catalina:      "d64577e04b6f1aa1279034d64a5634c8619b1c0f0da038539284dc71c119b0d6"
    sha256 cellar: :any,                 mojave:        "ff5c7e7cd9ac4b61a482d733ab9081f540ca38d3a875f00106cf3a0f8c6db3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce92e4bb455dd60dbcc197602fcd2935e1f0e9083ea224ab859917d72e828f20"
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

    on_macos do
      args << "--with-gssapi"
    end

    on_linux do
      args << "--with-gssapi=#{Formula["krb5"].opt_prefix}"
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
