class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https://curl.se/download/curl-8.14.1.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_14_1/curl-8.14.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.14.1.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.14.1.tar.bz2"
  sha256 "5760ed3c1a6aac68793fc502114f35c3e088e8cd5c084c2d044abdf646ee48fb"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a208325a56e95796533140b94783a70603e8e78718249b7d3580da12da24ebaf"
    sha256 cellar: :any,                 arm64_sonoma:  "9e23c9408e31d5e0aada20daa57dd13f012b5430410c78ee6d9dadfc81b2fb16"
    sha256 cellar: :any,                 arm64_ventura: "3533a79f542d152fe7eac26c7cbeaeaf141eff9c85debc32db1681857cd2ca91"
    sha256 cellar: :any,                 sonoma:        "cf79c9d7b13b861cea4359140ea82e97b2d1bbca1083d2dbe8b74b7fae4051d7"
    sha256 cellar: :any,                 ventura:       "a09d7b8ad2616b22848e5dd0bb52bae7e7cab1517cd1245cb53af1b3e2a9eb7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ab501f75ec3305e4b4c624c15d1b0042645dbbf0f73e5975032ca37284bd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ab4d16878ac6b3cee935dbe5e27c290b671566c4352c41bd9982dc5b7620be"
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
