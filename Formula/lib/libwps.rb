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
    manifest_sha256 "f865eafa1e130ba605d09005b83fda213cf0da058f500d99dd5821f0e64e6a74"
    sha256 cellar: :any, arm64_golden_gate: "ac83e8aefc29399d28b8c8b496c12e812f3da70c8ff1465cca7bf65a1765ff0a"
    sha256 cellar: :any, arm64_tahoe:       "a75290a7d54f3cb390c2f52ac6b054128c997f759ca10a5c47dc307389adce86"
    sha256 cellar: :any, arm64_sequoia:     "c8011ddc1463a58b34c8d955c6d71a1e010c715cd80eb91a682876682f31c8ef"
    sha256 cellar: :any, arm64_linux:       "82db6eb6383d97c8da2a9e24a5dbcd6840ac66045d29b718942aac28d010d188"
    sha256 cellar: :any, x86_64_linux:      "b251e1764025508d089a6336710a813d8d557bfe023d9e1a84d694f69af108b3"
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
