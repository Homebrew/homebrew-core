class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.15/libwps-0.4.15.tar.xz"
  sha256 "5b29f1ccd5a0f0737d0f8ff49a1f1c01f5988833c028e7882525136c40674ccc"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libwps(?:/|[._-])v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "eee1f927f23c1ec744aa3896f83d493d5da86c20fe76e0c1c33234ad8a2f2fe1"
    sha256 cellar: :any,                 arm64_tahoe:       "a1a1238d044325d8d266d1d13531ce09f837f8fe7ee2fe1474971456f3b5fe6b"
    sha256 cellar: :any,                 arm64_sequoia:     "1fcecd4b70835db56d8ee1e19e7fb07ab34cd1f43d64dce1900baa57a59b2949"
    sha256 cellar: :any,                 arm64_sonoma:      "53e4b189ac3f6a5707904498385226b759f0c8a222378682cad4303c0169b83e"
    sha256 cellar: :any,                 arm64_ventura:     "6d72183ffc9b82c287d94ccdb14d6e78a71da5a62d10c10f2ff50ab74908087f"
    sha256 cellar: :any,                 arm64_monterey:    "4ea281eea24cce797c6f21a41a6d9be0911343b28bf58b5e4585442959745127"
    sha256 cellar: :any,                 arm64_big_sur:     "1fb8baf32244abfb5d39ffc8f5286a7fa0111333e57c3d43f1f337f6ff43100a"
    sha256 cellar: :any,                 sonoma:            "eafcfcc4568c94cb334613505826f62aeee27380acab0ddff6f88c5e832ee128"
    sha256 cellar: :any,                 ventura:           "05d18e5787514170da6f2b7e2bb58f449bb4c282c9e35ff32ddf4b13747ee458"
    sha256 cellar: :any,                 monterey:          "6609484542bfcf5046702cf470e20da2dd99ef1597b6e60ca08858e5975afbe6"
    sha256 cellar: :any,                 big_sur:           "bf9c54ae1889bf3dcc90034d9b5a11bd14c452b69463343c3bd8f221031109d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66e66c4fe9ca468d38f275f3fafeb4c5fcdabffc65f7f09c4256f10454421a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1947ed7197be31c9abf52b092a535de6d3d1416c9fef915661ba81da4cee37b6"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  # Backport upstream GCC patch
  # https://sourceforge.net/p/libwps/code/ci/fb4ad0beb7aea9f3fdd18d8b4c06d7c28dd69199/
  patch :DATA

  deny_network_access!

  def install
    # Installing Doxygen docs trips up make install
    system "./configure", "--without-docs", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    CPP
    system ENV.cc, "test.cpp", "-o", "test",
                  "-I#{include}/libwps-0.4",
                  "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                  "-L#{lib}", "-lwps-0.4",
                  "-L#{formula_opt_lib("librevenge")}", "-lrevenge-0.0"
    system "./test"
  end
end

__END__
commit fb4ad0beb7aea9f3fdd18d8b4c06d7c28dd69199
Author: Caolán McNamara <caolan.mcnamara@collabora.com>
Date:   Tue Nov 24 23:21:44 2026 +0000

    use the long double overloads of ldexp and pow
    
    std::ldexpl and std::powl are missing from libstdc++ before GCC 14, so
    clang with an older libstdc++ fails:
    
        libwps_internal.cpp:216:8: error: no member named 'ldexpl' in namespace 'std'; did you mean simply 'ldexpl'?
        Multiplan.cpp:947:16: error: no member named 'powl' in namespace 'std'; did you mean simply 'powl'?
    
    since:
    
    commit 00a1a6001cdb37bd48b89f765e0b096e1001072f
    Date:   Tue Sep 1 11:13:29 2026 +0200
    
        all: change code to use long double instead of double for main values       note: do not expect change as librevenge only accept double as argument. quattro pro[qpw]: accept to read unused cell styles.

diff --git a/src/lib/Multiplan.cpp b/src/lib/Multiplan.cpp
index 0365955..831a3ca 100644
--- a/src/lib/Multiplan.cpp
+++ b/src/lib/Multiplan.cpp
@@ -944,7 +944,7 @@ bool MultiplanParser::readDouble(long double &value)
 		}
 		if (!ok) break;
 	}
-	value *= sign*std::powl(10.,exponant-0x40);
+	value *= sign*std::pow(10.L,exponant-0x40);
 	input->seek(pos+8, librevenge::RVNG_SEEK_SET);
 	return ok;
 }
diff --git a/src/lib/libwps_internal.cpp b/src/lib/libwps_internal.cpp
index c5755cc..47938fd 100644
--- a/src/lib/libwps_internal.cpp
+++ b/src/lib/libwps_internal.cpp
@@ -213,7 +213,7 @@ bool readDouble8(RVNGInputStreamPtr &input, long double &res, bool &isNaN)
 	}
 
 	exp -= 0x3ff;
-	res = std::ldexpl(mantisse, exp);
+	res = std::ldexp(mantisse, exp);
 	if (sign == -1)
 	{
 		res *= -1.;
@@ -262,7 +262,7 @@ bool readDouble10(RVNGInputStreamPtr &input, long double &res, bool &isNaN)
 	}
 
 	exp -= 0x3fff;
-	res = std::ldexpl(mantisse, exp);
+	res = std::ldexp(mantisse, exp);
 	if (sign == -1)
 	{
 		res *= -1.;
