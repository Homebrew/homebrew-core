class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.9.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_9_1/curl-8.9.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.9.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.9.1.tar.bz2"
  sha256 "b57285d9e18bf12a5f2309fc45244f6cf9cb14734e7454121099dd0a83d669a3"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d0bc66626fc78a034e365084de6f3eeee218cf57b1b184248b1c5e5e5b8785f"
    sha256 cellar: :any,                 arm64_ventura:  "2cfa6df78dd8930d3325fa3261137b98e7c3203101eda4663547ed35ed4bf1c6"
    sha256 cellar: :any,                 arm64_monterey: "e39baf7b3ab1c3fe02f3c1dfcd496f19b6cfa5bdab9938785449589592d737df"
    sha256 cellar: :any,                 sonoma:         "a4869433de9e2a0cd1f62ca9adac05b2556875b232cae3c57fe9f5270102f3a2"
    sha256 cellar: :any,                 ventura:        "fb8d735358f2a294c47ac76615c930b197cacefc92737b20a0c684d730e27a4c"
    sha256 cellar: :any,                 monterey:       "cad6d2e6ed9918454c9986c1299c01409cc71212b23c334851b18494aa67e558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07004c1e8957c22da26a29908759d13ed9a2c11d5b08387ad24b9e599123d97a"
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
  depends_on "openssl@3"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "openldap"
  uses_from_macos "zlib"

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

    system "./buildconf" if build.head?

    args = %W[
      --disable-silent-rules
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
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system bin/"curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
