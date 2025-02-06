class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.12.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_12_0/curl-8.12.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.12.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.12.0.tar.bz2"
  sha256 "5a85adbe401ed3b998ee1128524e9b045feb39577f3c336f6997e7a4afaafcd7"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "59ac285d151a18b955ef1e5bdb726961dc852fd187c30684d1af4cf9d50c128d"
    sha256 cellar: :any,                 arm64_sonoma:  "c9e02e728de16ce3219ff693fa4eb591852534784d9d6da493a93718310a19d6"
    sha256 cellar: :any,                 arm64_ventura: "385c19b6df0841b7c30a1f8a507648b67ea474eb1d4f9cf8d9c905facab4efb3"
    sha256 cellar: :any,                 sonoma:        "5220cdbc04b05725dbadd2460baad164679d80e0d0f78fcc48d058d1dae429c4"
    sha256 cellar: :any,                 ventura:       "daee8e6b75c624d55fa7989ba13363dafeae942ac1a1a13210e831f528734741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33618b2cb991cf2b95b41d068e9dfea640d496cc452f9eead1443be6b3e0053"
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
  uses_from_macos "zlib"

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
  end

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
