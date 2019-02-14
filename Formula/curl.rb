class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.64.0.tar.bz2"
  sha256 "d573ba1c2d1cf9d8533fadcce480d778417964e8d04ccddcc76e591d544cf2eb"

  bottle do
    cellar :any
    sha256 "e5fa214a00a00fa80d76bd05db14e5c176a6be7bedeb86d748f5aa2969344f88" => :mojave
    sha256 "7349c533e22662c05ef5039696c3e8a7cd8d8a696797040c9c6bf27134662feb" => :high_sierra
    sha256 "0191dd2c0b129db3fcc10de4e5f61891ebe481a376cec04f8a2a4df5b389e9cb" => :sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

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
