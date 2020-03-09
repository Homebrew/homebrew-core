class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  revision 1

  stable do
    url "https://curl.haxx.se/download/curl-7.69.0.tar.bz2"
    sha256 "668d451108a7316cff040b23c79bc766e7ed84122074e44f662b8982f2e76739"

    # The below three patches all fix critical bugs. Remove them with curl 7.69.1.
    patch do
      url "https://github.com/curl/curl/commit/8aa04e9a24932b830bc5eaf6838dea5a3329341e.patch?full_index=1"
      sha256 "77595ec475e692bd24832e0e6e98de5d68a43bf7199c632ae0443fcb932791fb"
    end

    patch do
      url "https://github.com/curl/curl/commit/e040146f22608fd92c44be2447a6505141a8a867.patch?full_index=1"
      sha256 "f4267c146592067e84eacb62cdb22e0a35636699a8237470ccaf27d68cb17a86"
    end

    patch do
      url "https://github.com/curl/curl/commit/64258bd0aa6ad23195f6be32e6febf7439ab7984.patch?full_index=1"
      sha256 "afeb69e09b3402926acd40d76f6b28d9790ac1f1e080f4eb3f2500d5aaf46971"
    end
  end

  bottle do
    cellar :any
    sha256 "24aa9504342f77774aee3567b70b5067bf610fcdb5863cd0791ecaec67a8fa1f" => :catalina
    sha256 "d0d9389ecd80e156f43bbbec2cdf90a09502f4bd300b74868a9bb82358e80e58" => :mojave
    sha256 "540af1e3466f38cc2fe0a4d9cde8e3cf11b644dba4bc9aa2e97a0f4ecca142a0" => :high_sierra
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
