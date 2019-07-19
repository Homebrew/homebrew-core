class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.65.3.tar.bz2"
  sha256 "0a855e83be482d7bc9ea00e05bdb1551a44966076762f9650959179c89fce509"

  bottle do
    cellar :any
    sha256 "e80e6d5551ef94025883515e677a925a9ea5cb8ea85392af284afa621b0eb006" => :mojave
    sha256 "ac76e250c9d06fbef9402ca42121842c4c7344ee10958dd07373fe31561eb8be" => :high_sierra
    sha256 "ef005d10feaf3e6c7c4a3bd75b00fa947402e19956858969ed3abdc9b30089dd" => :sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  uses_from_macos "openssl"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-darwinssl
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
