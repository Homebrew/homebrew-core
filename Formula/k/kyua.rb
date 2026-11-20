class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/freebsd/kyua"
  url "https://github.com/freebsd/kyua/releases/download/kyua-0.15.2/kyua-0.15.2.tar.gz"
  sha256 "469499eab896790a46b2083dfe89f09c8cad3bf79ce45848619a61f287b68837"
  license "BSD-3-Clause"
  head "https://github.com/freebsd/kyua.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "6fdb8de88659d594876e883bdbfa0f0a943d894783323a0bd769cb73f8a6d557"
    sha256 arm64_tahoe:       "4905d096a462bd0097740684d968bf204140269a1c7982a40bd7149c9235e0ca"
    sha256 arm64_sequoia:     "963855fa6f8e41b41fbf9ce5d43bfcb4bf04ee3e7cb7194315b5c1f47c8c397e"
    sha256 arm64_linux:       "a5e2e755f72e1c5bfef5116abcf557751b83995ec1670c419f5a03296b5ecb24"
    sha256 x86_64_linux:      "eb3d40d567c56e6467bc765ac6218a339ec5e4da382c5f16b94317c1c9a28739"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "atf"
  depends_on "lua"
  depends_on "lutok"

  uses_from_macos "sqlite"

  deny_network_access!

  def install
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("lua")}/lua"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-atf"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    kyuafile = testpath/"Kyuafile"
    kyuafile.write <<~KYUA
      syntax(2)

      test_suite("sanity_check")

      atf_test_program{name="atf_test"}
      plain_test_program{name="plain_test"}
      tap_test_program{name="tap_test"}
    KYUA

    atf_test_c = testpath/"atf_test.c"
    atf_test_c.write <<~C
      #include <atf-c.h>

      ATF_TC_WITHOUT_HEAD(tc1);
      ATF_TC_BODY(tc1, tc)
      {
        int i = 2;
        ATF_REQUIRE_EQ(i * 2, 4);
      }

      ATF_TP_ADD_TCS(tp)
      {
        ATF_TP_ADD_TC(tp, tc1);

        return atf_no_error();
      }
    C

    flags = shell_output("pkgconf --cflags --libs atf-c").chomp.split
    system ENV.cc, atf_test_c, "-o", "atf_test", *flags

    plain_test = testpath/"plain_test"
    plain_test.write <<~SH
      #!/bin/sh
      echo "this is a plain test that always passes"
    SH
    plain_test.chmod(0555)

    tap_test = testpath/"tap_test"
    tap_test.write <<~SH
      #!/bin/sh
      echo "1..2"
      echo "ok 1"
      echo "not ok 2 # SKIP: demonstrates that not ok + SKIP => does not fail"
    SH
    tap_test.chmod(0555)

    system bin/"kyua", "test", "-k", kyuafile
  end
end
