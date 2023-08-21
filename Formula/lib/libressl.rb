class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.7.3.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.7.3.tar.gz"
  sha256 "7948c856a90c825bd7268b6f85674a8dcd254bae42e221781b24e3f8dc335db3"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "92af271440e96175044bc6976f171eab677d3c2cadccb37f92dffdb73f56d4d1"
    sha256 arm64_monterey: "41bda964c02b2e5de90918e46979ab251ea865227c936fd3c89b641a7570a98e"
    sha256 arm64_big_sur:  "1b8de42a012f5c7bf6ba0c6ba9bb75cf292a0695fc64e4d5579c3d78cfda2537"
    sha256 ventura:        "101035f5a4ce0fe52b7340e710470b9932de57d85810730c8f7ead7c671b9196"
    sha256 monterey:       "2c54083fc264c565013434ec47d3c8f27e9e8e2c6c9a3aadbe71a9510926b726"
    sha256 big_sur:        "068a040109a368aca77822ef96db06f4695642adce1c7e134df069a23a2eaea5"
    sha256 x86_64_linux:   "dab5dda456e0e745a240a2886e6f82fe71c64e1e71e9d303b25b1f00e59e22c3"
  end

  head do
    url "https://github.com/libressl-portable/portable.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    rm_f pkgetc/"cert.pem"
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the SystemRoots
      keychain. To add additional certificates (e.g. the certificates added in
      the System keychain), place .pem files in
        #{etc}/libressl/certs

      and run
        #{opt_bin}/openssl certhash #{etc}/libressl/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise LibreSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/libressl/openssl.cnf", :exist?,
            "LibreSSL requires the .cnf file for some functionality"

    # Check LibreSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
