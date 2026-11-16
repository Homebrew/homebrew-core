class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.4.0.tar.gz"
  sha256 "cfeb6c372cc35c99e373d0e099c809a30dbf4e3a67c1cf9ad929e745d744a381"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "3b5935a2638a5cf6fa4d7e6b554c89309b4730feae7f73ac3c4dcbca256b68dd"
    sha256 arm64_tahoe:       "dfd6d7b03700aac925bde99493389f29c2b3435cef5ed6549355ca67ae242a55"
    sha256 arm64_sequoia:     "09cff1b97c12ddef8fc7e996a82685afea8add1f01199cdfd612ec8eb9cf8ee1"
    sha256 arm64_linux:       "12220e60c2d461a5b1ade8d65a950adcf51236c084779f69e398c4ee0d273da1"
    sha256 x86_64_linux:      "2cb8d0014fff06baa054842fc2be74e80336ed20d80ae69d0a6cdee2abcc921b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "linux-pam"
  end

  # Apply open PR to support OpenSSL 4
  patch do
    url "https://github.com/duosecurity/duo_unix/commit/c17f4845ca553a6cd33f6554aabcf7e726fc167b.patch?full_index=1"
    sha256 "7f1692ba71faddd872b034cce36804f70f5d23a53462dcf4a08f9d0a7ee1293b"
    type :unofficial
    resolves "https://github.com/duosecurity/duo_unix/pull/410"
  end

  deny_network_access!

  def install
    # Darwin declares `strftime_l` in <xlocale.h> rather than <time.h>
    ENV.append_to_cflags "-include xlocale.h" if OS.mac?

    File.write("build-date", time.to_i)
    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--with-pam=#{lib}/pam/",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                             "-f", "foobar", "echo", "SUCCESS"
  end
end
