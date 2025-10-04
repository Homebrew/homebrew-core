class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.16.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_16_0/curl-8.16.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.16.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.16.0.tar.bz2"
  sha256 "9459180ab4933b30d0778ddd71c91fe2911fab731c46e59b3f4c8385b1596c91"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e07029f638dd578dd22d267eb829966b391f8f844e94e0cad1c951b77bf2f9c"
    sha256 cellar: :any,                 arm64_sequoia: "75474687cf0837b5658d6f4af211cf8d83403d1106845947850426b11dc0651c"
    sha256 cellar: :any,                 arm64_sonoma:  "6c417ac2b92ff32b75cfdfa74e7561a351e3a98a59bd1950b6381bdfcffa061d"
    sha256 cellar: :any,                 arm64_ventura: "dc3a619c320850493cddb46e43449297a8a149e993be40a834dd463fe8584804"
    sha256 cellar: :any,                 sonoma:        "8d206c6b15c5fa824dcaceaf8719fd6c15300ad5f43e552c5435342d3409ab82"
    sha256 cellar: :any,                 ventura:       "913e149f132fe197528674c605122b65aded074f234679685865f581f6ace84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d946b8686c1043e3400bebb75abeb597f02be8ecf76d103f8563dae2f418a2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ecafe13b24606512adb4c2fa189f1bddfcefa8ad160e360eb3e4ad5419d6dc"
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
  depends_on "libnghttp3"
  depends_on "libngtcp2"
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
    if build.stable? && stable.mirrors.grep(%r{\Ahttps?://(www\.)?github\.com/}).first.exclude?(tag_name)
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
      --with-default-ssl-backend=openssl
      --with-librtmp
      --with-libssh2
      --with-nghttp3
      --with-ngtcp2
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

    # Verify QUIC and HTTP3 support
    system bin/"curl", "--verbose", "--http3-only", "--head", "https://cloudflare-quic.com"

    # Check dependencies linked correctly
    curl_features = shell_output("#{bin}/curl-config --features").split("\n")
    %w[brotli GSS-API HTTP2 HTTP3 IDN libz SSL zstd].each do |feature|
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
