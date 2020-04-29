class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.70.0.tar.xz"
  sha256 "032f43f2674008c761af19bf536374128c16241fb234699a55f9fb603fcfbae7"

  bottle do
    cellar :any
    sha256 "400500fede02f9335bd38c16786b2bbf5e601e358dfac8c21e363d2a8fdd8fac" => :catalina
    sha256 "f082c275f9af1e8e93be12b63a1aff659ba6efa48c8528a97e26c9858a6f95b6" => :mojave
    sha256 "ad023093c252799a4c60646a149bfe14ffa6984817cf463a6f0e98f6551057fe" => :high_sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-secure-transport
      --without-ca-bundle
      --without-ca-path
    ]

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
