class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/freebsd/kyua"
  url "https://github.com/freebsd/kyua/releases/download/kyua-0.15.2/kyua-0.15.2.tar.gz"
  sha256 "469499eab896790a46b2083dfe89f09c8cad3bf79ce45848619a61f287b68837"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/freebsd/kyua.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e038bd1f20ff456c4438e8db91b3d3d9030999bd557a586fd89f4145762653c1"
    sha256 arm64_golden_gate: "7172a8473d0287b071ede11452992535a294318c42065f033fba6809d117de23"
    sha256 arm64_tahoe:       "25fd8164cac9153fc714b3f08998e6c1eb5fee3b0ac3e90c3a7dd84e73279e02"
    sha256 arm64_sequoia:     "6ab256cdeeb7b8b84ccdf4ba4d1f014c5366ce83d0b6eddda0414c48d5d1e423"
    sha256 arm64_linux:       "c6ead836de8d2a0a9f3575ff69ff63dc6c5ffbdeee78eccebe7f5a6ab52454b9"
    sha256 x86_64_linux:      "5d67667f81d6acdd87b4d0d4f4d93f27b62535fc934ff491fa3f6217055f4ce1"
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
