class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.4.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_4_0/curl-8.4.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.4.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.4.0.tar.bz2"
  sha256 "e5250581a9c032b1b6ed3cf2f9c114c811fc41881069e9892d115cc73f9e88c6"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f48e7cfd9ba46477ad697f8210da298e5eae1843439fdd640ec728910f0c38df"
    sha256 cellar: :any,                 arm64_ventura:  "870ee57d4b7019e19c0e42635dc0c9bba6b7607da9a5962f291628ba97685bd2"
    sha256 cellar: :any,                 arm64_monterey: "97744e84a4c8933a9e6ca5a0ed0a31b1c038aeb4d78c7885e92ceaef91d10026"
    sha256 cellar: :any,                 sonoma:         "141bcd5522e8607efd85f6a8e2fb3696521a94c179c7fec9bbbf586a2f6e2058"
    sha256 cellar: :any,                 ventura:        "8f875574e1136997a54cec6288cfcad909856432fa184624b703a1a368ac0f81"
    sha256 cellar: :any,                 monterey:       "ff4a0ad23bfc772c20d1a9af2b73c0f5193ce9fb9dfc1d1195ca1f6333b1f6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38cf63d990afcb1fffcc401820e6119358ca0ee0d45875512ed19e1b37a9dba0"
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
