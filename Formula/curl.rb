class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.55.1.tar.bz2"
  mirror "http://curl.askapache.com/download/curl-7.55.1.tar.bz2"
  sha256 "e5b1a92ed3b0c11f149886458fa063419500819f1610c020d62f25b8e4b16cfb"

  bottle do
    cellar :any
    sha256 "70155209f9f87b3874198c614c21d50230f4b6ea96bdcf9000ec1d12e9a588ed" => :sierra
    sha256 "e9365d5d662b9b21df65a01be1ab8bc7e3bf3b2cb4364cb4e3fd56d4af2ec616" => :el_capitan
    sha256 "a2e024b135b021bc9159b45578faa9cb4e5a465cabedea5da2ae927f53920778" => :yosemite
  end

  keg_only :provided_by_osx

  option "with-rtmpdump", "Build with RTMP support"
  option "with-libssh2", "Build with scp and sftp support"
  option "with-c-ares", "Build with C-Ares async DNS support"
  option "with-gssapi", "Build with GSSAPI/Kerberos authentication support."
  option "with-libmetalink", "Build with libmetalink support."
  option "with-nghttp2", "Build with HTTP/2 support (requires OpenSSL)"

  deprecated_option "with-rtmp" => "with-rtmpdump"
  deprecated_option "with-ssh" => "with-libssh2"
  deprecated_option "with-ares" => "with-c-ares"

  # HTTP/2 support requires OpenSSL 1.0.2+ or LibreSSL 2.1.3+ for ALPN Support
  # which is currently not supported by Secure Transport (DarwinSSL).
  if MacOS.version < :mountain_lion || build.with?("nghttp2")
    depends_on "openssl"
  else
    option "with-openssl", "Build with OpenSSL instead of Secure Transport"
    depends_on "openssl" => :optional
  end

  depends_on "pkg-config" => :build
  depends_on "rtmpdump" => :optional
  depends_on "libssh2" => :optional
  depends_on "c-ares" => :optional
  depends_on "libmetalink" => :optional
  depends_on "nghttp2" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # cURL has a new firm desire to find ssl with PKG_CONFIG_PATH instead of using
    # "--with-ssl" any more. "when possible, set the PKG_CONFIG_PATH environment
    # variable instead of using this option". Multi-SSL choice breaks w/o using it.
    if MacOS.version < :mountain_lion || build.with?("openssl") || build.with?("nghttp2")
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_lib}/pkgconfig"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
      args << "--with-ca-path=#{etc}/openssl/certs"
    else
      args << "--with-darwinssl"
      args << "--without-ca-bundle"
      args << "--without-ca-path"
    end

    args << (build.with?("libssh2") ? "--with-libssh2" : "--without-libssh2")
    args << (build.with?("libmetalink") ? "--with-libmetalink" : "--without-libmetalink")
    args << (build.with?("gssapi") ? "--with-gssapi" : "--without-gssapi")
    args << (build.with?("rtmpdump") ? "--with-librtmp" : "--without-librtmp")

    if build.with? "c-ares"
      args << "--enable-ares=#{Formula["c-ares"].opt_prefix}"
    else
      args << "--disable-ares"
    end

    system "./configure", *args
    system "make", "install"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert File.exist?("test.pem")
    assert File.exist?("certdata.txt")
  end
end
