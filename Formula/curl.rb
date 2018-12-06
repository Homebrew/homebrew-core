class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.62.0.tar.bz2"
  mirror "http://curl.mirror.anstey.ca/curl-7.62.0.tar.bz2"
  sha256 "7802c54076500be500b171fde786258579d60547a3a35b8c5a23d8c88e8f9620"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c8e77ac89d9bc55f5ba07c73ace897b3f4c01655f07e0204d050f444c7dd0d7a" => :mojave
    sha256 "e38e0b5bcb62fc94e2bde394cc6c784493b9027abece24fa87e376cef6aafad5" => :high_sierra
    sha256 "f7a22903747bd1b3ed9c0af8638336c9ff4d3517c4fd46f6dc2c42d44ce68e2f" => :sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

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
  depends_on "c-ares" => :optional
  depends_on "libmetalink" => :optional
  depends_on "libssh2" => :optional
  depends_on "nghttp2" => :optional
  depends_on "rtmpdump" => :optional

  def install
    system "./buildconf" if build.head?

    # Allow to build on Lion, lowering from the upstream setting of 10.8
    ENV.append_to_cflags "-mmacosx-version-min=10.7" if MacOS.version <= :lion

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
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
