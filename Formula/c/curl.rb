class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.10.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_10_1/curl-8.10.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.10.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.10.1.tar.bz2"
  sha256 "3763cd97aae41dcf41950d23e87ae23b2edb2ce3a5b0cf678af058c391b6ae31"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "100108ddf12c4b3a9e7877e3f8c18bdfe4a0a51b273ffe74ea7545d0308450af"
    sha256 cellar: :any,                 arm64_sonoma:  "91ba6f1d338eb2eb2b833efa332f43a4f9a562e120ed85661632e7dd20c3ed2a"
    sha256 cellar: :any,                 arm64_ventura: "6526f3319a007cb30ec844458dfa4a6c9979d8ffb7ef810b6183998ce4c43d04"
    sha256 cellar: :any,                 sonoma:        "c9e0fde442aef9d270c54eda97b16b9e1dfc946b0fe99d945839e654fc4de84e"
    sha256 cellar: :any,                 ventura:       "f4ed8d096a11e53f8741cda841783fa0e904b5a862f6062be1ed1703444a4b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4284c064a03c57efbcac375ce3c2df8718653eebbedbf54a7957d94a223dc9ad"
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
    filename = (testpath/"test.tar.gz")
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
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
