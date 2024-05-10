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
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "d26dcef01fd3158c59dec70673ebbdcecc44bdffc51b735a45d018f3046d0dfd"
    sha256 cellar: :any,                 arm64_ventura:  "abef4ff5922a5046cf31afc38dcdfec4cce7985a93d997276a8a9fe822782103"
    sha256 cellar: :any,                 arm64_monterey: "562cd9cf121cb54692bdaade8319bc070421c426779fdfd4e7d9ce59d81e304c"
    sha256 cellar: :any,                 sonoma:         "c98c05f1441d74c327717bddf1e4ea0d914a2f325550885c6b5084d6f03875ef"
    sha256 cellar: :any,                 ventura:        "30c589452ee996815867e03b5104b7464b2580a991cb686d69485ab7c2348984"
    sha256 cellar: :any,                 monterey:       "26ea8f03d564d0b7fb27dc9416bf989fb012185636e8cabf8bd6680b11b9dfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f439e638e5fb4c63c8aa359eb5effd351fb8f3a6e59736281544cd1d739dc4f"
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

  # Fixes `curl: (23) Failed writing received data to disk/application`
  # Remove in next release
  patch do
    url "https://github.com/curl/curl/commit/b30d694a027eb771c02a3db0dee0ca03ccab7377.patch?full_index=1"
    sha256 "da4ae2efdf05169938c2631ba6e7bca45376f1d67abc305cf8b6a982c618df4d"
  end

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
