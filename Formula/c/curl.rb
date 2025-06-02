class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.

  license "curl"

  stable do
    url "https://curl.se/download/curl-8.14.0.tar.bz2"
    mirror "https://github.com/curl/curl/releases/download/curl-8_14_0/curl-8.14.0.tar.bz2"
    mirror "http://fresh-center.net/linux/www/curl-8.14.0.tar.bz2"
    mirror "http://fresh-center.net/linux/www/legacy/curl-8.14.0.tar.bz2"
    sha256 "efa1403c5ac4490c8d50fc0cabe97710abb1bf2a456e375a56d960b20a1cba80"

    # fix https://github.com/curl/curl/issues/17473
    # curl_multi_add_handle() returning OOM when using more than 400 handles
    patch do
      url "https://github.com/curl/curl/commit/d16ccbd55de80c271fe822f4ba8b6271fd9166ff.patch?full_index=1"
      sha256 "d30d4336e2422bedba66600b4c05a3bed7f9c51c1163b75d9ee8a27424104745"
    end
  end

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "69efd2fd516be31f0c79b1af0a989c52f4d64d9003d39a0cefc6e64350e738c6"
    sha256 cellar: :any,                 arm64_sonoma:  "e552078c530a8315d4877daf4906bf7745bd24cc3941b7f44980bba20db5ff46"
    sha256 cellar: :any,                 arm64_ventura: "5034cef9debaa38a5466af6b88694c4430f7851470a5b24f0afb0322fae9e607"
    sha256 cellar: :any,                 sonoma:        "e30b8516c64ac2ed9b2e0ac4afecdb6f5166327a6e5f1b900ece864992b9a320"
    sha256 cellar: :any,                 ventura:       "78cef1a6e06b1a5118e33b907a3adadf8c7861573a69c201f9e6524502c8a5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a9a666d78f78e18ea810640354b311dc13fa08680ecac0aac0ac452ff1300a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5123da4f2bb51d5ddb60cfed48b7f5223f1dadef133ebc892d292636924517"
  end

  head do
    url "https://github.com/curl/curl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "openldap"
  uses_from_macos "zlib", since: :sierra

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
  end

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

    # Use our `curl` formula with `wcurl`
    inreplace "scripts/wcurl", 'CMD="curl "', "CMD=\"#{opt_bin}/curl \""

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = %W[
      --disable-silent-rules
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-secure-transport
      --with-default-ssl-backend=openssl
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

    args += if OS.mac? && MacOS.version >= :ventura
      %w[
        --with-apple-idn
        --without-libidn2
      ]
    else
      %w[
        --without-apple-idn
        --with-libidn2
      ]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = testpath/"test.tar.gz"
    system bin/"curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    # Check dependencies linked correctly
    curl_features = shell_output("#{bin}/curl-config --features").split("\n")
    %w[brotli GSS-API HTTP2 IDN libz SSL zstd].each do |feature|
      assert_includes curl_features, feature
    end
    curl_protocols = shell_output("#{bin}/curl-config --protocols").split("\n")
    %w[LDAPS RTMP SCP SFTP].each do |protocol|
      assert_includes curl_protocols, protocol
    end

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_path_exists testpath/"test.pem"
    assert_path_exists testpath/"certdata.txt"

    with_env(PKG_CONFIG_PATH: lib/"pkgconfig") do
      system "pkgconf", "--cflags", "libcurl"
    end
  end
end
