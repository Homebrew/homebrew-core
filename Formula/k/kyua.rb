class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/freebsd/kyua"
  url "https://github.com/freebsd/kyua/releases/download/kyua-0.15.0/kyua-0.15.0.tar.gz"
  sha256 "08b0d498d1440c49413ef651ace410ef5bab83d48a2c5024b0a0e500da96d8c4"
  license "BSD-3-Clause"
  head "https://github.com/freebsd/kyua.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "ce841a460112cecacd966c486318298df83e1f2676aa4944d89214a71ae962e2"
    sha256 arm64_tahoe:       "65b2c61afcc098c9f59374acfe5627c66edd958a5df2b5f69f9ab06e168359a7"
    sha256 arm64_sequoia:     "336fb34683c4b05447dce2656d4113837e4d166775e4bae03e5a306f583ae0e5"
    sha256 arm64_linux:       "8195f9e6649d87bc9ff362553cbd473685d7b5ae44a2ea7914c1da9b3196792d"
    sha256 x86_64_linux:      "f5e3897c933facff15119ee8fc9ca954af5bc4c8336dc12897855bf623fd782a"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "atf"
  depends_on "lua"
  depends_on "lutok"

  uses_from_macos "sqlite"

  # Fix GCC build of test helpers that lost `static` in 0.15.0
  patch do
    url "https://github.com/freebsd/kyua/commit/41222b1393499096a73be5f3b7d9c45b274bbfb6.patch?full_index=1"
    sha256 "d37fc322a827f511dd1289ae822c81b15429db4e6e27420c1ee96a61e4b909e7"
    type :unofficial
    resolves "https://github.com/freebsd/kyua/pull/328"
  end

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
    kyuafile.write <<~EOF
      syntax(2)

      test_suite("sanity_check")

      atf_test_program{name="atf_test"}
      plain_test_program{name="plain_test"}
      tap_test_program{name="tap_test"}
    EOF

    atf_test_c = testpath/"atf_test.c"
    atf_test_c.write <<~EOF
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
    EOF

    flags = shell_output("pkgconf --cflags --libs atf-c").chomp.split
    system ENV.cc, atf_test_c, "-o", "atf_test", *flags

    plain_test = testpath/"plain_test"
    plain_test.write <<~EOF
      #!/bin/sh
      echo "this is a plain test that always passes"
    EOF
    plain_test.chmod(0555)

    tap_test = testpath/"tap_test"
    tap_test.write <<~EOF
      #!/bin/sh
      echo "1..2"
      echo "ok 1"
      echo "not ok 2 # SKIP: demonstrates that not ok + SKIP => does not fail"
    EOF
    tap_test.chmod(0555)

    system bin/"kyua", "test", "-k", kyuafile
  end
end
