class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-4.3.2.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-4.3.2.tar.gz"
  sha256 "edf01aee24c65d69e6a9efcb9d44bcda682ff9d4f3bbbd95e794e1dfa90847b5"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "76d955fdb9c556608ba23fe7f0474ff81f0cf6b321ef60a74b80e092d3c35c80"
    sha256 arm64_sequoia: "cf88284fbd82632e6e368d8dda525c9cdc8a20533c142fa9d7f9eb5522fbf845"
    sha256 arm64_sonoma:  "8903b4833944e4435b5b5ed8bc08462887786726a7e432ad47c20aba50b18071"
    sha256 sonoma:        "39e22c373554bd43f99b10a57e4f8f93b48ad2076b0929e060f7a711b6489845"
    sha256 arm64_linux:   "f67fe7ea826433c71eb04c827d050e40fafc45f2d87cd5ca53cf00749fa18499"
    sha256 x86_64_linux:  "5b34254c709120de67438ae5494e9971c2b043f27f10484cba41853c6dbd9d70"
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
    assert_path_exists HOMEBREW_PREFIX/"etc/libressl/openssl.cnf",
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
