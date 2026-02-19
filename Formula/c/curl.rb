class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.18.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_18_0/curl-8.18.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.18.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.18.0.tar.bz2"
  sha256 "ffd671a3dad424fb68e113a5b9894c5d1b5e13a88c6bdf0d4af6645123b31faf"
  license "curl"
  revision 2

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48707c8f48875dba2094a3d8ebec5b0440382a0fec2c032ce8f5f7e3090c2963"
    sha256 cellar: :any,                 arm64_sequoia: "f4abfd17ff0f3a507ab2436e1d9415f2f0ed49db2b764a7428b505ff81973cdf"
    sha256 cellar: :any,                 arm64_sonoma:  "56dc2fef6a1290fddf0d2613979d23ffc24e4d39d71d6193874eecc1ffe946fe"
    sha256 cellar: :any,                 sonoma:        "a0027833d5cc65535ad7441b716ef0a84373fd4a6e0d2cb7276b610a1a884b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "605e87afaf7f589f227c9eab7574c3e7913d5a6eb8dea954230023fb1baceb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fda5084a92a23173877cb7c4bbae01bcf9e8e9eb951b1612b8d2a0798f9c591"
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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
    system "pkgconf", "--cflags", "libcurl"
  end
end
