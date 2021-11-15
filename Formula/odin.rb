class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.13.0.tar.gz"
  sha256 "ae88c4dcbb8fdf37f51abc701d94fb4b2a8270f65be71063e0f85a321d54cdf0"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "f24379e907c9f66dcf9bf07327499982194ea03cc95a3c8ce4029f728bbcfbe8"
    sha256 cellar: :any, big_sur:  "8756628900882ce7b6492cd63a16192c66420c792c4ae6bc625104f10cd4ad91"
    sha256 cellar: :any, catalina: "a3ae074bcf9f1b096fd0ff73ec3e4169580cbd9c992eaf96df00381fb4bc4aab"
    sha256 cellar: :any, mojave:   "4f2a22f846642e17dd24a44ec9bd5e00a768facbeba1ea76f2b528f1407c6669"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm@11"

  uses_from_macos "libiconv"

  # Fix test for 11.0. This should be removed with the next version.
  # https://github.com/odin-lang/Odin/pull/768
  patch :DATA

  def install
    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm@11"].opt_bin}:$PATH"
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
