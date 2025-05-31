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
    sha256 cellar: :any,                 arm64_sequoia: "4e1a9fa77c2e2c80589750f54fafcd2f014a3251aef28cd7159ae21f63407ce6"
    sha256 cellar: :any,                 arm64_sonoma:  "1cee86f0eaf6551365e196be37dd6b8c5ba4ceba762dfb562acc31cb37f453ae"
    sha256 cellar: :any,                 arm64_ventura: "2dd30282842f21a92915c671e0c7ef48cd100f3c8a9ec0dba92e042de1d561c0"
    sha256 cellar: :any,                 sonoma:        "3d8219f0c288493ac8c49ff3038dbdfd14bad581c6e384939693fcdaeaa91a6f"
    sha256 cellar: :any,                 ventura:       "02364a79a7e5efb5ec6711ae3dc67c06f60a876477c9a8c04df328de01248e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4acfcc5932b7e7a6a52f487cf41560bda3fb02c69f34bf37f55499b70eb803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b902e408c4295747033a0a608d9593ff11d247283d1aa939b666af9ceb28e27"
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
    inreplace "scripts/wcurl", "CMD=\"curl \"", "CMD=\"#{Formula["curl"].opt_bin}/curl\""

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
