class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.1.2.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_1_2/curl-8.1.2.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.1.2.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.1.2.tar.bz2"
  sha256 "b54974d32fd610acace92e3df1f643144015ac65847f0a041fdc17db6f43f243"
  license "curl"
  revision 1

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bd5703ca8717e141933b2a99ceca383f6f9c89dde495161063fc0b9be0b3289"
    sha256 cellar: :any,                 arm64_monterey: "d10b95b4831a80162e63e95321ea743a07c48567f07d200b8f8d9e755aec4385"
    sha256 cellar: :any,                 arm64_big_sur:  "903965a1ff4f348d29400360895c7e80cfdc409a58ab9baa181920becf3982f0"
    sha256 cellar: :any,                 ventura:        "c5b69e6af1635b0884a654e91dc707b352a691a43bd79c774706aabc273d331d"
    sha256 cellar: :any,                 monterey:       "b20e0b0d54d1629c6fc09979572a83db734c6eb6b611d71d12f814275a486238"
    sha256 cellar: :any,                 big_sur:        "7577bb988799c0959bf7a766519cbd08a4b80c6d4c68768a2ccfba1de8bb385b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b3b8dde04541f3fe2e0cd4c996909597cf9dd3473a1e298d21e25853529082"
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
