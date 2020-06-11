class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.70.0.tar.xz"
  sha256 "032f43f2674008c761af19bf536374128c16241fb234699a55f9fb603fcfbae7"

  bottle do
    cellar :any
    sha256 "bafc3e44ec798a160b690d0cf3d3e321faedf8fef56a08ca90f975f5a47e2034" => :catalina
    sha256 "d7e22f7455fcb6f7ab20b0867940db23cf0c22b6bd6bc85d069787b5fbea5ce2" => :mojave
    sha256 "41b6cd0f010ee6fecd8be06033115f8e8027aecc2144876c84d70ea1e1902cbf" => :high_sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

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
