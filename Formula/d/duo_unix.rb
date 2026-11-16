class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.4.0.tar.gz"
  sha256 "cfeb6c372cc35c99e373d0e099c809a30dbf4e3a67c1cf9ad929e745d744a381"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "c96422b355aee7a106152b8814cb5eb63c8e30bf24809d747fab3f3ab27707ad"
    sha256 arm64_tahoe:       "2a8b171bb538ad09eb8cd138e66f63440e46fe321417a986400acdfcf8f661d8"
    sha256 arm64_sequoia:     "138d70cb765c13071f07c27aa4a29e20f69e53a60402436f0111373a8eef8af0"
    sha256 arm64_linux:       "9352118f9732aaba7070e5842990f8041c587eb690a99f7a0ce8256749d92603"
    sha256 x86_64_linux:      "844305881fdb956899339963617a3098f32b08efa10ed6ef7e797d0c022f26a2"
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
