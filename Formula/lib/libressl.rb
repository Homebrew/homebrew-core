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
    sha256 arm64_sonoma:   "42da82b5fc36e79bb0c3ced6e0f17143581ca09524c16f2bc5df6b0d0bdb64e1"
    sha256 arm64_ventura:  "1c15edeeda153f9a9f71dcdf3929ac04d447e05bd4b4e6b639d4f38049f72ab2"
    sha256 arm64_monterey: "c0b959f3f07391e2d85fbf381d0a5192fcd9493698421b29d50af166778e0e81"
    sha256 sonoma:         "28c1c87ab3b05a4e91be27804291e6c09f18b95ee35cbead63489ca53562b727"
    sha256 ventura:        "e6bcdc4353f2eb8d1678ab5b14cfaf25ef41b41f9b965f348d8438b9e0b45ef7"
    sha256 monterey:       "c3d435c7c0bb68558847f5b5b6b5aef289323c389441f927efc77f089146c82f"
    sha256 x86_64_linux:   "2f30efdef2f483235760c974e2eed83889caae4387b90ee1316e1d1730765d23"
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
