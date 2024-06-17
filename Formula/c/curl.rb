class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.8.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_8_0/curl-8.8.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.8.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.8.0.tar.bz2"
  sha256 "40d3792d38cfa244d8f692974a567e9a5f3387c547579f1124e95ea2a1020d0d"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2c86a65bd81527768bfe1464538cdafa4c84ee8bde7ee8fca55e3eb7b99c93d"
    sha256 cellar: :any,                 arm64_ventura:  "41cd3aa1fb8fda366927e67109db45bbb38e5b0d4147770d1d7d2253b73a66ed"
    sha256 cellar: :any,                 arm64_monterey: "8ddd1307221e3a07c85540f5f960e6461c44f7a08a7fc82ad2ebe8ce640b45a4"
    sha256 cellar: :any,                 sonoma:         "f658e4e63d62acf2d42b63393291ba780e693e994c54a26b1df5de61a2b874ca"
    sha256 cellar: :any,                 ventura:        "d42520fffc0aff7d901e564cf03d8a60756cf2f5c07e6cbfd9f011eabd96692f"
    sha256 cellar: :any,                 monterey:       "42cc69a0abd1bdc7dd390c7a61b61574f6dfd86f6f9e450161e2138aa85850f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98513bfbe492f9217b3142f2bbeed216972e06951e201a7e1d5f2d84f7d457e0"
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
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
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
