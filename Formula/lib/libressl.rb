class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-4.4.1.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-4.4.1.tar.gz"
  sha256 "290cdf1b53c086255dc302f118b98602a444e9ae6d11e9bfdd8c9b1b60aa3a22"
  license "OpenSSL"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e349a8c3490ae8d9119467135c2e068f6fec359d196b809fdb1d6623677bae61"
    sha256 arm64_tahoe:       "aebf532e1c5a0a09848bc0908c32146df91868b610c3fbe05367b27a4261e1b5"
    sha256 arm64_sequoia:     "ffb499a0617f07c4390820afc1e075861e058fc0acd66c3041ef1c4669c0ec6a"
    sha256 arm64_linux:       "386316ba49a6dcb5e483af7b3472a34e8ea0b797eb433727b40ad6eb957db9ec"
    sha256 x86_64_linux:      "c0761706ff693594ddd6e25324808ccb54eb39f3c9fa07c0004175c5e923bd94"
  end

  head do
    url "https://github.com/libressl/portable.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  deny_network_access!

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

  post_install_steps do
    symlink "{{etc}}/ca-certificates/cert.pem", "{{pkgetc}}/cert.pem", overwrite: true
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
