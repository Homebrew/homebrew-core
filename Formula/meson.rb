class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.45.0/meson-0.45.0.tar.gz"
  sha256 "3455abbc30a3fbd9cc8abb6d5fcdc42ce618665b95ac2c3ad7792a4a6ba47ce4"
  head "https://github.com/mesonbuild/meson.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :high_sierra
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :sierra
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :el_capitan
  end

  depends_on "python"
  depends_on "ninja"

  patch :DATA

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end

__END__
commit 121dd794564c253ae13006a3eb31f08bde24f57c
Author: Tom Schoonjans <Tom.Schoonjans@diamond.ac.uk>
Date:   Wed Mar 14 08:40:47 2018 +0000

    Add libtool compatible versioning support to macOS shared libraries

diff --git a/mesonbuild/backend/ninjabackend.py b/mesonbuild/backend/ninjabackend.py
index 0c774c15..f79a48f3 100644
--- a/mesonbuild/backend/ninjabackend.py
+++ b/mesonbuild/backend/ninjabackend.py
@@ -2420,7 +2420,8 @@ rule FORTRAN_DEP_HACK
             commands += linker.get_pic_args()
             # Add -Wl,-soname arguments on Linux, -install_name on OS X
             commands += linker.get_soname_args(target.prefix, target.name, target.suffix,
-                                               abspath, target.soversion,
+                                               abspath, target.soversion, target.ltversion,
+                                               os.path.join(self.environment.get_prefix(), self.environment.get_libdir()),
                                                isinstance(target, build.SharedModule))
             # This is only visited when building for Windows using either GCC or Visual Studio
             if target.vs_module_defs and hasattr(linker, 'gen_vs_module_defs_args'):
diff --git a/mesonbuild/compilers/c.py b/mesonbuild/compilers/c.py
index 2d141160..5c592007 100644
--- a/mesonbuild/compilers/c.py
+++ b/mesonbuild/compilers/c.py
@@ -84,7 +84,7 @@ class CCompiler(Compiler):
         # Almost every compiler uses this for disabling warnings
         return ['-w']

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         return []

     def split_shlib_to_parts(self, fname):
diff --git a/mesonbuild/compilers/compilers.py b/mesonbuild/compilers/compilers.py
index 034fef4e..e5e3d6bb 100644
--- a/mesonbuild/compilers/compilers.py
+++ b/mesonbuild/compilers/compilers.py
@@ -900,7 +900,7 @@ ICC_STANDARD = 0
 ICC_OSX = 1
 ICC_WIN = 2

-def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
     if soversion is None:
         sostr = ''
     else:
@@ -915,7 +915,15 @@ def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, i
         if soversion is not None:
             install_name += '.' + soversion
         install_name += '.dylib'
-        return ['-install_name', os.path.join('@rpath', install_name)]
+        args = ['-install_name', os.path.join(libdir, install_name)]
+        if version and len(version.split('.')) == 3:
+            splitted = version.split('.')
+            major = int(splitted[0])
+            minor = int(splitted[1])
+            revision = int(splitted[2])
+            args += ['-compatibility_version', '%d' % (major + minor + 1)]
+            args += ['-current_version', '%d.%d' % (major + minor + 1, revision)]
+        return args
     else:
         raise RuntimeError('Not implemented yet.')

@@ -1045,8 +1053,8 @@ class GnuCompiler:
     def split_shlib_to_parts(self, fname):
         return os.path.dirname(fname), fname

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
-        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
+        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_std_shared_lib_link_args(self):
         return ['-shared']
@@ -1113,7 +1121,7 @@ class ClangCompiler:
         # so it might change semantics at any time.
         return ['-include-pch', os.path.join(pch_dir, self.get_pch_name(header))]

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         if self.clang_type == CLANG_STANDARD:
             gcc_type = GCC_STANDARD
         elif self.clang_type == CLANG_OSX:
@@ -1122,7 +1130,7 @@ class ClangCompiler:
             gcc_type = GCC_MINGW
         else:
             raise MesonException('Unreachable code when converting clang type to gcc type.')
-        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def has_multi_arguments(self, args, env):
         myargs = ['-Werror=unknown-warning-option', '-Werror=unused-command-line-argument']
@@ -1196,7 +1204,7 @@ class IntelCompiler:
     def split_shlib_to_parts(self, fname):
         return os.path.dirname(fname), fname

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         if self.icc_type == ICC_STANDARD:
             gcc_type = GCC_STANDARD
         elif self.icc_type == ICC_OSX:
@@ -1205,7 +1213,7 @@ class IntelCompiler:
             gcc_type = GCC_MINGW
         else:
             raise MesonException('Unreachable code when converting icc type to gcc type.')
-        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_std_shared_lib_link_args(self):
         # FIXME: Don't know how icc works on OSX
diff --git a/mesonbuild/compilers/cs.py b/mesonbuild/compilers/cs.py
index f78e364b..ced6e3ef 100644
--- a/mesonbuild/compilers/cs.py
+++ b/mesonbuild/compilers/cs.py
@@ -41,7 +41,7 @@ class CsCompiler(Compiler):
     def get_link_args(self, fname):
         return ['-r:' + fname]

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         return []

     def get_werror_args(self):
diff --git a/mesonbuild/compilers/d.py b/mesonbuild/compilers/d.py
index 474e1bd7..ef4b353c 100644
--- a/mesonbuild/compilers/d.py
+++ b/mesonbuild/compilers/d.py
@@ -89,9 +89,9 @@ class DCompiler(Compiler):
     def get_std_shared_lib_link_args(self):
         return ['-shared']

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         # FIXME: Make this work for Windows, MacOS and cross-compiling
-        return get_gcc_soname_args(GCC_STANDARD, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+        return get_gcc_soname_args(GCC_STANDARD, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_feature_args(self, kwargs, build_to_src):
         res = []
diff --git a/mesonbuild/compilers/fortran.py b/mesonbuild/compilers/fortran.py
index f9fcc1cd..cd08a546 100644
--- a/mesonbuild/compilers/fortran.py
+++ b/mesonbuild/compilers/fortran.py
@@ -93,8 +93,8 @@ end program prog
     def split_shlib_to_parts(self, fname):
         return os.path.dirname(fname), fname

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
-        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
+        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_dependency_gen_args(self, outtarget, outfile):
         # Disabled until this is fixed:
diff --git a/mesonbuild/compilers/java.py b/mesonbuild/compilers/java.py
index a8138d75..8cd6ce2b 100644
--- a/mesonbuild/compilers/java.py
+++ b/mesonbuild/compilers/java.py
@@ -25,7 +25,7 @@ class JavaCompiler(Compiler):
         self.id = 'unknown'
         self.javarunner = 'java'

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         return []

     def get_werror_args(self):

