class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/freebsd/kyua"
  url "https://github.com/freebsd/kyua/releases/download/kyua-0.14.1/kyua-0.14.1.tar.gz"
  sha256 "3caf30a7e316f4f21c32e1c419ec80371fe113e3eed10ba1db9e6efc7ee15ecb"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/freebsd/kyua.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "df0a26d9a6b340e9503b8fb2f5bd49a1612fafb68a16f2046f0157a3945ba394"
    sha256 arm64_sequoia: "9b7a4d39f2619978508b4aaca8e298fd2d7b3571ad20616c8742b27e1526f9dc"
    sha256 arm64_sonoma:  "2960aa79f59cfe291e1d58f60bb7d7d76fc73d076c2167015e1950001e828c70"
    sha256 sonoma:        "9b8c73b9b4cdf1a3c8c7706e81f598df30944a4b67a28492920a82b14456c92c"
    sha256 arm64_linux:   "e239437e15b41ff4af492f36a66ff06e7630112d0bb7828a89685cb3c1948273"
    sha256 x86_64_linux:  "3a8e53115d5afe1d92d1d9db3c3468cc4755c38b869b24530e5d92fae670d5e2"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "atf"
  depends_on "lua"
  depends_on "lutok"

  uses_from_macos "sqlite"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"

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
