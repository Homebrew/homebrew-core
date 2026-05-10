class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.20.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_20_0/curl-8.20.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.20.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.20.0.tar.bz2"
  sha256 "4be48e69cf467246cb97d369b85d78a08528f2b37cffef2418ee16e6a4eb596e"
  license "curl"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "292a95f8922562eb97609df58f6f2765a0c1f912899e161827ac2fd288146789"
    sha256 cellar: :any,                 arm64_sequoia: "de32ed6b3ff9420e5559be0bab5944c9ee7f30078a69be57fd810746a21d06a3"
    sha256 cellar: :any,                 arm64_sonoma:  "3cf2d6da13f3a932f80017c72058810eb5de2409f95d857ef96535049ff4b1f3"
    sha256 cellar: :any,                 sonoma:        "842054ace2ad5405139509eb6a7e9f96d3691224ce1f8c41258118ec1d146a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f7fbed23fd2d5c154afef0b9f99697b06115fd2d19f6b9ba5574bcd5a7471c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56889f9aa7a44053503b64e77f68387d410d0c04bd5e9decaf08c48fcc846ea"
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
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "openldap"

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
      --with-ssl=#{Formula["openssl@4"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-default-ssl-backend=openssl
      --with-libssh2
      --with-nghttp3
      --with-ngtcp2
      --without-libpsl
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
    ]

    args += if OS.mac?
      %w[
        --with-apple-sectrust
        --with-gssapi
      ]
    else
      ["--with-gssapi=#{Formula["krb5"].opt_prefix}"]
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
    %w[LDAPS SCP SFTP].each do |protocol|
      assert_includes curl_protocols, protocol
    end

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_path_exists testpath/"test.pem"
    assert_path_exists testpath/"certdata.txt"

    ENV["PKG_CONFIG_PATH"] = lib/"pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", Formula["zlib-ng-compat"].lib/"pkgconfig" unless OS.mac?
    # TODO: remove when `openssl@4` is not keg_only anymore.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@4"].opt_lib/"pkgconfig"
    system "pkgconf", "--cflags", "libcurl"
  end
end
