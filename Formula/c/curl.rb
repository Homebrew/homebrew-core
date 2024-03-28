class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.7.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_7_1/curl-8.7.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.7.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.7.1.tar.bz2"
  sha256 "05bbd2b698e9cfbab477c33aa5e99b4975501835a41b7ca6ca71de03d8849e76"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d781bc589b8740c836c3339a2eb5fa6ad87727bec92f294d3ba9e01955329599"
    sha256 cellar: :any,                 arm64_ventura:  "af732a6303664d58d7ba6185a4f3604e6db6653dbac247d07617edb1619475a7"
    sha256 cellar: :any,                 arm64_monterey: "c1c14ab94a76bc667466a573b14f658c6ac1532aec787988bb7dc6d2d3ed145e"
    sha256 cellar: :any,                 sonoma:         "52cb38432f13d3e4c9f3d8c2035edc90bff33f3182725b819b48faecd496a8d2"
    sha256 cellar: :any,                 ventura:        "679a579128450f432f67e89fede3d5adddb4b0e9e7ffe47e3f54d258a204dd19"
    sha256 cellar: :any,                 monterey:       "5daeb595d977fddd1c854f1e36f91a8694ba993b2432430962a1636f78d787e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f7c32e66ce2050bbf7e26dfa98b5fa15a2a1ad82be4292a8629ebc730fe20c"
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
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

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
