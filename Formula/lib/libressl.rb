class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-4.2.1.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-4.2.1.tar.gz"
  sha256 "6d5c2f58583588ea791f4c8645004071d00dfa554a5bf788a006ca1eb5abd70b"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ba6ef9fa38ea1b994cb15718d4dd77104f8c140b1f2b7561c2ccbbebb77af94b"
    sha256 arm64_sequoia: "6133145affd65d37db277d64f5e19ef4744917acc5fae5974abbde7c8d472a85"
    sha256 arm64_sonoma:  "aa48217c34ad123558c0001e5d40b3e1076371b22b1c9eb722bfd0cc35c382e1"
    sha256 sonoma:        "383e3ef03088ef5348c1b36e828ae2af3d098876c1265f8920a9138412a26798"
    sha256 arm64_linux:   "2eddbafa15b069f1abdae1d3df6a74cf5f3b4c30e0db216ee5fb2106e226f9d3"
    sha256 x86_64_linux:  "8690dae24ab88821c36d409f6ecf04ba2d85011fc92540d23d97c7ca72873f43"
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
