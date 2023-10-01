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
    sha256 cellar: :any,                 arm64_sonoma:   "e7297f57780ed14527f5b44a760350038c72f8f1721100ea4c0c94e8d691fd07"
    sha256 cellar: :any,                 arm64_ventura:  "f4c4ea2e973a69e155da1683d25501579e00ccb9820351f3c15f02433c81c599"
    sha256 cellar: :any,                 arm64_monterey: "15c13521434d2016eed9809ace5f1ca2f128efb335e761ae64e97ba4d57ca4af"
    sha256 cellar: :any,                 arm64_big_sur:  "86d7ae1fbf0107d881ee72874f0e5f172ec220f36f7f3e337c3805a17fcd35c6"
    sha256 cellar: :any,                 sonoma:         "66b0434033fedd9c5c2a85a50a0dcdf2f53a81d9a2ad42b4c96fad7031736683"
    sha256 cellar: :any,                 ventura:        "13675dbbf6572b82991346a96a592dfb214980934aadbd1b104a5b6d8c483745"
    sha256 cellar: :any,                 monterey:       "3763039f868f0f99ac3559db3f4b7c7b2ad79b5ebe6f0f991280587b60d21dab"
    sha256 cellar: :any,                 big_sur:        "083eaa48224fd208caf336582e439756d45be2f059a5c281e74086198e269f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58025fa4023beeeb6423b00ebce6fa3d0784c4aed39e47a0fd9e175b7dd2a715"
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
