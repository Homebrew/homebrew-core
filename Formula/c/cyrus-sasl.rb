class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"
  revision 4

  bottle do
    sha256 arm64_golden_gate: "244e8389554db8ee28e01455456a62e72e18f006430ad95536609a1db4fcd090"
    sha256 arm64_tahoe:       "f852e28532a0e63209f6704134adf775f2df531753d507ab4c9e2babe6543a3c"
    sha256 arm64_sequoia:     "16e3956c0ff2617a467953aa8591b55cee40c0285d3a3fa59ce0d439c471ba58"
    sha256 arm64_linux:       "ac7aaa2c5a23febd8db9e9585a0ef9e828fcf5cd508320c3d741a6240ddcbefc"
    sha256 x86_64_linux:      "c79e51a24f74445d5ffd93ef531ddf9b86b97ba3ad756c7c9a59a11408aaf5ce"
  end

  head do
    url "https://github.com/cyrusimap/cyrus-sasl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  def install
    # Workaround for missing time.h. Fixed upstream but backport would require autotools deps
    # https://github.com/cyrusimap/cyrus-sasl/commit/266f0acf7f5e029afbb3e263437039e50cd6c262
    # Also force C standard on newer GCC to avoid build failures
    if build.stable?
      odie "Remove workarounds!" if version > "2.1.28"
      ENV.append_to_cflags "-include time.h"
      if ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) >= 15
        ENV.append "CFLAGS", "-std=gnu17"
      end
    end

    args = %w[
      --disable-macos-framework
      --disable-sample
      --disable-silent-rules
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <sasl/saslutil.h>
      #include <assert.h>
      #include <stdio.h>
      int main(void) {
        char buf[123] = "\\0";
        unsigned len = 0;
        int ret = sasl_encode64("Hello, world!", 13, buf, sizeof buf, &len);
        assert(ret == SASL_OK);
        printf("%u %s", len, buf);
        return 0;
      }
    CPP

    system ENV.cxx, "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lsasl2"
    assert_equal "20 SGVsbG8sIHdvcmxkIQ==", shell_output("./test")
  end
end
