class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.13.0.tar.gz"
  sha256 "ae88c4dcbb8fdf37f51abc701d94fb4b2a8270f65be71063e0f85a321d54cdf0"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "772509e10bf0a73af78b51e4f85309eb6d25e0078d1f2fa02bfa2d252e0055ca" => :catalina
    sha256 "8e86193674aeecfc0b103cd067c39f2ac3df41d72f3875676fc21e397c9748b1" => :mojave
    sha256 "87d21cd84cc602f553a8b9533ad2fafcf8fb8d987bb5f8a25d27239a3d2d177d" => :high_sierra
  end

  depends_on "llvm"

  uses_from_macos "libiconv"

  # Fix test for 11.0. This should be removed with the next version.
  # https://github.com/odin-lang/Odin/pull/768
  patch :DATA

  def install
    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin"
    assert_equal "Hellope!\n", `./hellope`
  end
end

__END__
diff --git a/src/main.cpp b/src/main.cpp
index 13d9e53..6dbe658 100644
--- a/src/main.cpp
+++ b/src/main.cpp
@@ -341,12 +341,12 @@ i32 linker_stage(lbGenerator *gen) {
 					String lib_name = lib;
 					lib_name = remove_extension_from_path(lib_name);
 					lib_str = gb_string_append_fmt(lib_str, " -framework %.*s ", LIT(lib_name));
-				} else if (string_ends_with(lib, str_lit(".a"))) {
+                } else if (string_ends_with(lib, str_lit(".a")) || string_ends_with(lib, str_lit(".o")) || string_ends_with(lib, str_lit(".dylib"))) {
+                    // For:
+                    // object
+                    // dynamic lib
 					// static libs, absolute full path relative to the file in which the lib was imported from
 					lib_str = gb_string_append_fmt(lib_str, " %.*s ", LIT(lib));
-				} else if (string_ends_with(lib, str_lit(".dylib"))) {
-					// dynamic lib
-					lib_str = gb_string_append_fmt(lib_str, " %.*s ", LIT(lib));
 				} else {
 					// dynamic or static system lib, just link regularly searching system library paths
 					lib_str = gb_string_append_fmt(lib_str, " -l%.*s ", LIT(lib));
@@ -431,8 +431,12 @@ i32 linker_stage(lbGenerator *gen) {
 				" -e _main "
 			#endif
 			, linker, object_files, LIT(output_base), LIT(output_ext),
+            #if defined(GB_SYSTEM_OSX)
+                "-lSystem -lm -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -L/usr/local/lib",
+            #else
+                "-lc -lm",
+            #endif
 			lib_str,
-			"-lc -lm",
 			LIT(build_context.link_flags),
 			LIT(build_context.extra_linker_flags),
 			link_settings);
@@ -2097,12 +2101,12 @@ int main(int arg_count, char const **arg_ptr) {
 						String lib_name = lib;
 						lib_name = remove_extension_from_path(lib_name);
 						lib_str = gb_string_append_fmt(lib_str, " -framework %.*s ", LIT(lib_name));
-					} else if (string_ends_with(lib, str_lit(".a"))) {
-						// static libs, absolute full path relative to the file in which the lib was imported from
-						lib_str = gb_string_append_fmt(lib_str, " %.*s ", LIT(lib));
-					} else if (string_ends_with(lib, str_lit(".dylib"))) {
-						// dynamic lib
-						lib_str = gb_string_append_fmt(lib_str, " %.*s ", LIT(lib));
+                    } else if (string_ends_with(lib, str_lit(".a")) || string_ends_with(lib, str_lit(".o")) || string_ends_with(lib, str_lit(".dylib"))) {
+           				// For:
+           				// object
+           				// dynamic lib
+                        // static libs, absolute full path relative to the file in which the lib was imported from
+                        lib_str = gb_string_append_fmt(lib_str, " %.*s ", LIT(lib));
 					} else {
 						// dynamic or static system lib, just link regularly searching system library paths
 						lib_str = gb_string_append_fmt(lib_str, " -l%.*s ", LIT(lib));
@@ -2181,7 +2185,11 @@ int main(int arg_count, char const **arg_ptr) {
 				#endif
 				, linker, LIT(output_base), LIT(output_base), LIT(output_ext),
 				lib_str,
-				"-lc -lm",
+                #if defined(GB_SYSTEM_OSX)
+                    "-lSystem -lm -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -L/usr/local/lib",
+                #else
+                    "-lc -lm",
+                #endif
 				LIT(build_context.link_flags),
 				LIT(build_context.extra_linker_flags),
 				link_settings);
