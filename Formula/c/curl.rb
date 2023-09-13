class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.3.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_3_0/curl-8.3.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.3.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.3.0.tar.bz2"
  sha256 "051a217095671e925a129ba9e2ff2e223b44b08399003ba50738060955d010ff"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "901965403320a6aacdac96e06bc5f140db827565ba7c2cc7bc1e4337756fda2e"
    sha256 cellar: :any,                 arm64_monterey: "9e710bfdd4db8210ec411f30ba62ae97be6de559dff0a88800edfb4dfa0cbf5f"
    sha256 cellar: :any,                 arm64_big_sur:  "256a85d2260cc215ca3c99d5db4814cedbfee4c88ac914c84bb2244134ff9b19"
    sha256 cellar: :any,                 ventura:        "fbfa808993c8fb09118d92f9c2b6723540962c90c4d4090913bd01b6bbc858a7"
    sha256 cellar: :any,                 monterey:       "62f9f9d2476ec7c90a91fabc7b7aacdcf4f4954c60047fa957e32902f4de8587"
    sha256 cellar: :any,                 big_sur:        "22ec28e3af18cbbf3fa801505adcf6716ca2345529878624bc11f6638f51ee4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adc728399b63df44ee1ba274583c2d26a4dc93d646ecaf5aefce070f2fd785e"
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
  depends_on "openssl@3"
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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    assert_match tag_name, stable.mirrors.grep(/github\.com/).first,
                 "Tag name #{tag_name} is not found in the GitHub mirror " \
                 "URL! Please make sure the URL is correct"

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
