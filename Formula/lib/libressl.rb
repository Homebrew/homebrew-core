class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.9.1.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.9.1.tar.gz"
  sha256 "6da0b954695f7ee62b03f64200a8a4f02af93717b60cce04ab6c8df262c07a51"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sonoma:   "06abc74de8f2fc86a08468d4f00c9c7180da57dee193b01bc4e4995edd547a26"
    sha256 arm64_ventura:  "c4391b2a64d0d7f23e5825dec22ba06f5cefb345d8a9427c409f962ae19792a3"
    sha256 arm64_monterey: "8f5005381e925d8b1a42754abee9b2d64a78ada2efa96dafd4cc1c4accb0e019"
    sha256 sonoma:         "1cee42dd9f05e325a7b855e7d45213cc25a2717228f67e22e56b3855dabc46aa"
    sha256 ventura:        "4768967cddf3ea7dbc5a5dab5ce2d2ba407b008e321a9ec3866cb03e40d616ff"
    sha256 monterey:       "c3751bc04b715e0d466744159ae8e56d8f30c4244666ac698d1414bb36305f2f"
    sha256 x86_64_linux:   "4ecd76c909b9a874ff81e2c24d80dcf7e24c45d023081ee64aa848be6bbbbaae"
  end

  head do
    url "https://github.com/libressl/portable.git", branch: "master"

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
