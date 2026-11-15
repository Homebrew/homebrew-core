class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/freebsd/kyua"
  url "https://github.com/freebsd/kyua/releases/download/kyua-0.15.1/kyua-0.15.1.tar.gz"
  sha256 "19adf19c1cce83b0484ee786ff813a1745e2aa4c2e1a0cceefb41da91c43c87c"
  license "BSD-3-Clause"
  head "https://github.com/freebsd/kyua.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "0756318b41a0e6d4aac7d48f330eb663684d7da1230ba3b659cf7d5a09c34662"
    sha256 arm64_tahoe:       "7cee7f1432163540dc14341a92c9770d3d697cfff13600eceff232889d45e7ef"
    sha256 arm64_sequoia:     "c45ea692a99d93b6b9cf2e49d2f5f731b624ba1de65ad385bed98affdc6113cc"
    sha256 arm64_linux:       "dd49b6a184f2ac7bcdc6bf4ee3a051f34cfc366df9e5768e50e6f4bebee27e26"
    sha256 x86_64_linux:      "757c190a69bd998653deec0d1be17084dbb6decbf5c4124cab8da819672c6753"
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
