class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", revision: "5270c34b4c00", using: :hg
  version "634"
  revision 9
  head "https://hg.linkmauve.fr/touhou", using: :hg

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b7880e24a56f914a2eba61055a67aeb2e3f4ad0ecd311c1b6e27295b748c926"
    sha256 cellar: :any,                 arm64_big_sur:  "0911d15863c316fc09f7bf623932220fcce67ad4e16dbdb614a72f11d73df227"
    sha256 cellar: :any,                 monterey:       "b973c7a742e8838a3f5bfd0ba94193c39bd81543d7a8d19f98f07713d30e4b4f"
    sha256 cellar: :any,                 big_sur:        "d3e12e01e5b18f44435ae49ad65726fd71d72c0f9bdb0b54169dc2f1d894b2e0"
    sha256 cellar: :any,                 catalina:       "d1b56e807242ae33bb7a577c2359daa5e233ad73e1e81dc4b642546eb93545a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cd0dc9eba59afb98766c0554cf603688064ceed66bbec1ac199bd42ff8d469"
  end

  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "gtk+3"
  depends_on "libcython"
  depends_on "libepoxy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.10"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  # Fix for parallel cythonize
  # It just put setup call in `if __name__ == '__main__'` block
  patch :p0, :DATA

  def install
    python = "python3.10"
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/Language::Python.site_packages(python)

    # hg can't determine revision number (no .hg on the stage)
    inreplace "setup.py", /(version)=.+,$/, "\\1='#{version}',"

    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    # Set default game path to pkgshare
    inreplace libexec/"bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  def caveats
    <<~EOS
      The default path for the game data is:
        #{pkgshare}/game
    EOS
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"pytouhou", "--help"
  end
end

__END__
--- setup.py	2019-10-21 08:55:06.000000000 +0100
+++ setup.py	2019-10-21 08:56:15.000000000 +0100
@@ -172,29 +172,29 @@
 if not os.path.exists(temp_data_dir):
     os.symlink(os.path.join(current_dir, 'data'), temp_data_dir)

+if __name__ == '__main__':
+    setup(name='PyTouhou',
+        version=check_output(['hg', 'heads', '.', '-T', '{rev}']).decode(),
+        author='Thibaut Girka',
+        author_email='thib@sitedethib.com',
+        url='http://pytouhou.linkmauve.fr/',
+        license='GPLv3',
+        py_modules=py_modules,
+        ext_modules=cythonize(ext_modules, nthreads=nthreads, annotate=debug,
+                                language_level=3,
+                                compiler_directives={'infer_types': True,
+                                                    'infer_types.verbose': debug,
+                                                    'profile': debug},
+                                compile_time_env={'MAX_TEXTURES': 128,
+                                                'MAX_ELEMENTS': 640 * 4 * 3,
+                                                'MAX_SOUNDS': 26,
+                                                'USE_OPENGL': use_opengl}),
+        scripts=['scripts/pytouhou'] + (['scripts/anmviewer'] if anmviewer else []),
+        packages=['pytouhou'],
+        package_data={'pytouhou': ['data/menu.glade']},
+        **extra)

-setup(name='PyTouhou',
-      version=check_output(['hg', 'heads', '.', '-T', '{rev}']).decode(),
-      author='Thibaut Girka',
-      author_email='thib@sitedethib.com',
-      url='http://pytouhou.linkmauve.fr/',
-      license='GPLv3',
-      py_modules=py_modules,
-      ext_modules=cythonize(ext_modules, nthreads=nthreads, annotate=debug,
-                            language_level=3,
-                            compiler_directives={'infer_types': True,
-                                                 'infer_types.verbose': debug,
-                                                 'profile': debug},
-                            compile_time_env={'MAX_TEXTURES': 128,
-                                              'MAX_ELEMENTS': 640 * 4 * 3,
-                                              'MAX_SOUNDS': 26,
-                                              'USE_OPENGL': use_opengl}),
-      scripts=['scripts/pytouhou'] + (['scripts/anmviewer'] if anmviewer else []),
-      packages=['pytouhou'],
-      package_data={'pytouhou': ['data/menu.glade']},
-      **extra)

-
-# Remove the link afterwards
-if os.path.exists(temp_data_dir):
-    os.unlink(temp_data_dir)
+    # Remove the link afterwards
+    if os.path.exists(temp_data_dir):
+        os.unlink(temp_data_dir)
