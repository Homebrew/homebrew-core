class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.13.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_13_0/curl-8.13.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.13.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.13.0.tar.bz2"
  sha256 "e0d20499260760f9865cb6308928223f4e5128910310c025112f592a168e1473"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "71f23540167a8ab38a56ae1ec35b12f726765d6706602e93efdaad31a99bf01d"
    sha256 cellar: :any,                 arm64_sonoma:  "e0d632af6097f17ca1d10d2cbe63f43fdf2dd58aa1a36a6e8cad11e7f72159a5"
    sha256 cellar: :any,                 arm64_ventura: "416ee6d14ce87952b11e325f9e320c068b657e3b5099ba50a34e7f5bbc68d634"
    sha256 cellar: :any,                 sonoma:        "49161bfb410f5a2f585256b452f9252319064f633789109f7f53941b28816b7b"
    sha256 cellar: :any,                 ventura:       "d6a522ebfb6b2b64f03911465d16ba15d4ce6b1e68d5cb5820c245c4f6ef8f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420cec3c2e6f55105664b0074c49119f736621646ca522fae976cbe759667a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c420f63845b2ed7c29f089cdb84981134173dab3b89b8e6c7b06f22630dcbec"
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

  # Fixes failure to download certdata.txt due to a redirect
  patch do
    url "https://github.com/curl/curl/commit/eeed87f0563d3ca73ff53813418d1f9f03c81fe5.patch?full_index=1"
    sha256 "f7461a8042ca8ef86492338458ccd79ee286d17773487513928d7ed6ae25818c"
  end

  # Fixes build on macOS 10.12 and earlier
  patch do
    url "https://github.com/curl/curl/commit/d7914f75aa8ecdd68cdbb130c1351a7432597fe4.patch?full_index=1"
    sha256 "2ba45be5c9238abc914c2a47cd604cbd08972583b310c9079b7b7909b352001b"
  end

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(/github\.com/).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

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
