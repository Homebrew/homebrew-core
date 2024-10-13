class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.9.2.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.9.2.tar.gz"
  sha256 "7b031dac64a59eb6ee3304f7ffb75dad33ab8c9d279c847f92c89fb846068f97"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9979b3595f6d02a80ff0116ad01f8ed851e00fdbb8fb8d6a45dfcbfd569c6c05"
    sha256 arm64_sonoma:   "8a693d60b9b442208116773760d403923bbe1b0fef78aa97817421d594ee53fa"
    sha256 arm64_ventura:  "7ab87499e353f7a0b57708ecd239e85cba5716bd4b352f549c43277a78d9477d"
    sha256 arm64_monterey: "0aa833fa1a9bb0be187b532fd57a1eae0570495b7a6ad7d8d6a8ef60a6b7ad7a"
    sha256 sonoma:         "f19dced1e6d79b56a351045968bea672c42092554a8df6d811d43f3e151fad98"
    sha256 ventura:        "04cb9a492d3a0105737c7baefbfd49ac74263b795391c53d6e501ed52bcb5839"
    sha256 monterey:       "c3668ac2b548fec36e85a005358fb85c64d7a6274858f44a39e1c94faf432c31"
    sha256 x86_64_linux:   "9a49c9d29fbc50e52e4eda1ca7e9ab89965a7e9d9f388a2c073417444e3c1aeb"
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
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
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
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
