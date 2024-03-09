class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.8.3.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.8.3.tar.gz"
  sha256 "a65f40e3ef6e3c9451c8318e6f2c454c367e67f09c0cde1849731a4d6ecc7272"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sonoma:   "275e20c1fd0d2dea082ece51d5bb91253d60a033f36f05d5a28602d11c3c70bf"
    sha256 arm64_ventura:  "919037dda29c47ebdc95f1b671267d0bb5da7a03738d7d574f91705abc435af7"
    sha256 arm64_monterey: "9b521a692c4ae45224e9d2f04548a9046515d943ad02eaec7e98413ff452921f"
    sha256 sonoma:         "1fd84082abf064c369328b9bf9a1b9e665401bc619448835f55a44c91a71e5df"
    sha256 ventura:        "752f831dbc389bd6d59d9d0d9f94f07de4e58945a5787d6a4aa1f886fd0ee0a6"
    sha256 monterey:       "f2fdf30340767dc723ce1002a3f70fbb62a18c3e6a97dbc759d8fe3817f909dd"
    sha256 x86_64_linux:   "bb4a7f805ea8b1fc995ad16687b31d8bb265ea91a6f717fe208b81e4c881e50f"
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
