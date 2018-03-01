class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.44.1/meson-0.44.1.tar.gz"
  sha256 "2ea1a721574adb23160b6481191bcc1173f374e02b0ff3bb0ae85d988d97e4fa"
  head "https://github.com/mesonbuild/meson.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :high_sierra
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :sierra
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :el_capitan
  end

  depends_on "python3"
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
commit bcada1520a0e7c9568034538ebefb8d4bad1d652
Author: Tom Schoonjans <Tom.Schoonjans@diamond.ac.uk>
Date:   Fri Nov 3 13:44:38 2017 +0000

    Add macOS linker versioning information

    This patch exploits the information residing in ltversion to set the
    -compatibility_version and -current_version flags that are passed to the
    linker on macOS.

diff --git a/mesonbuild/backend/ninjabackend.py b/mesonbuild/backend/ninjabackend.py
index 1057892c..f4fcb020 100644
--- a/mesonbuild/backend/ninjabackend.py
+++ b/mesonbuild/backend/ninjabackend.py
@@ -2349,7 +2349,8 @@ rule FORTRAN_DEP_HACK
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
index 9c1d1fca..5b663ed4 100644
--- a/mesonbuild/compilers/c.py
+++ b/mesonbuild/compilers/c.py
@@ -84,7 +84,7 @@ class CCompiler(Compiler):
         # Almost every compiler uses this for disabling warnings
         return ['-w']

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         return []

     def split_shlib_to_parts(self, fname):
@@ -93,7 +93,7 @@ class CCompiler(Compiler):
     # The default behavior is this, override in MSVC
     def build_rpath_args(self, build_dir, from_dir, rpath_paths, build_rpath, install_rpath):
         if self.id == 'clang' and self.clang_type == compilers.CLANG_OSX:
-            return self.build_osx_rpath_args(build_dir, rpath_paths, build_rpath)
+            return [] # no rpath on macOS!
         return self.build_unix_rpath_args(build_dir, from_dir, rpath_paths, build_rpath, install_rpath)

     def get_dependency_gen_args(self, outtarget, outfile):
diff --git a/mesonbuild/compilers/compilers.py b/mesonbuild/compilers/compilers.py
index 011c222c..7f329794 100644
--- a/mesonbuild/compilers/compilers.py
+++ b/mesonbuild/compilers/compilers.py
@@ -817,16 +817,6 @@ class Compiler:
     def get_instruction_set_args(self, instruction_set):
         return None

-    def build_osx_rpath_args(self, build_dir, rpath_paths, build_rpath):
-        if not rpath_paths and not build_rpath:
-            return []
-        # On OSX, rpaths must be absolute.
-        abs_rpaths = [os.path.join(build_dir, p) for p in rpath_paths]
-        if build_rpath != '':
-            abs_rpaths.append(build_rpath)
-        args = ['-Wl,-rpath,' + rp for rp in abs_rpaths]
-        return args
-
     def build_unix_rpath_args(self, build_dir, from_dir, rpath_paths, build_rpath, install_rpath):
         if not rpath_paths and not install_rpath and not build_rpath:
             return []
@@ -878,7 +868,7 @@ ICC_STANDARD = 0
 ICC_OSX = 1
 ICC_WIN = 2

-def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
     if soversion is None:
         sostr = ''
     else:
@@ -892,8 +882,16 @@ def get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, i
         install_name = prefix + shlib_name
         if soversion is not None:
             install_name += '.' + soversion
-        install_name += '.dylib'
-        return ['-install_name', os.path.join('@rpath', install_name)]
+        install_name += '.dylib'
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

@@ -1023,8 +1021,8 @@ class GnuCompiler:
     def split_shlib_to_parts(self, fname):
         return os.path.split(fname)[0], fname

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
-        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
+        return get_gcc_soname_args(self.gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_std_shared_lib_link_args(self):
         return ['-shared']
@@ -1091,7 +1089,7 @@ class ClangCompiler:
         # so it might change semantics at any time.
         return ['-include-pch', os.path.join(pch_dir, self.get_pch_name(header))]

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         if self.clang_type == CLANG_STANDARD:
             gcc_type = GCC_STANDARD
         elif self.clang_type == CLANG_OSX:
@@ -1100,7 +1098,7 @@ class ClangCompiler:
             gcc_type = GCC_MINGW
         else:
             raise MesonException('Unreachable code when converting clang type to gcc type.')
-        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def has_multi_arguments(self, args, env):
         myargs = ['-Werror=unknown-warning-option', '-Werror=unused-command-line-argument']
@@ -1174,7 +1172,7 @@ class IntelCompiler:
     def split_shlib_to_parts(self, fname):
         return os.path.split(fname)[0], fname

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         if self.icc_type == ICC_STANDARD:
             gcc_type = GCC_STANDARD
         elif self.icc_type == ICC_OSX:
@@ -1183,7 +1181,7 @@ class IntelCompiler:
             gcc_type = GCC_MINGW
         else:
             raise MesonException('Unreachable code when converting icc type to gcc type.')
-        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, is_shared_module)
+        return get_gcc_soname_args(gcc_type, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module)

     def get_std_shared_lib_link_args(self):
         # FIXME: Don't know how icc works on OSX
diff --git a/mesonbuild/compilers/cs.py b/mesonbuild/compilers/cs.py
index b8a4d13a..d0fc35c3 100644
--- a/mesonbuild/compilers/cs.py
+++ b/mesonbuild/compilers/cs.py
@@ -34,7 +34,7 @@ class MonoCompiler(Compiler):
     def get_link_args(self, fname):
         return ['-r:' + fname]

-    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, is_shared_module):
+    def get_soname_args(self, prefix, shlib_name, suffix, path, soversion, version, libdir, is_shared_module):
         return []

     def get_werror_args(self):
diff --git a/mesonbuild/compilers/d.py b/mesonbuild/compilers/d.py
index 9739f288..dda3cbed 100644
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

     def get_feature_args(self, kwargs):
         res = []
diff --git a/mesonbuild/compilers/fortran.py b/mesonbuild/compilers/fortran.py
index 2957a7c9..fc9de4a1 100644
--- a/mesonbuild/compilers/fortran.py
+++ b/mesonbuild/compilers/fortran.py
@@ -93,8 +93,8 @@ end program prog
     def split_shlib_to_parts(self, fname):
         return os.path.split(fname)[0], fname

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

