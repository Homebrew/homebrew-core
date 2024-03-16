class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", revision: "5270c34b4c00", using: :hg
  version "634"
  license "GPL-3.0-only"
  revision 9
  head "https://hg.linkmauve.fr/touhou", using: :hg

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e83c5e161c69cc14081b875a18043a08fa60db38b9a6703d290c5f6d80da95aa"
    sha256 cellar: :any,                 arm64_ventura:  "5529fede19cacc4e69b69985db53991070de184c7a4d50adb7649264b9df7ef3"
    sha256 cellar: :any,                 arm64_monterey: "b7da4dfc02540ed042b90827630e16026eeb6dbf0cc8e66657acf2e768a78776"
    sha256 cellar: :any,                 arm64_big_sur:  "a967c785a6916c4930e9dcbc3418eba15f26242ef1988a9fbdd272059bd45bd9"
    sha256 cellar: :any,                 sonoma:         "4844e4ee6302412c6814ace3d8429b82ea87adc30f6e0fe5970dcb757e532f57"
    sha256 cellar: :any,                 ventura:        "aaa8b69e4983370a51fd4799b5605e4d073610011170e8332eb674e5b4a6ccf2"
    sha256 cellar: :any,                 monterey:       "6a73d4bdbe1bf13e38d5a3a2ee5edbc6f41399894d28c5260d76ed7e02dbea8c"
    sha256 cellar: :any,                 big_sur:        "68865e9179adfb70ee4b113563e577f09ef0fe1bdbe1fe6f226931fe407e7fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb8bff86fc2cabba2ebc07150a44d8251dd66dc69168d0ad081c1c1ced81cda8"
  end

  # Repo fails to `hg pull` with recent `mercurial`
  deprecate! date: "2024-02-23", because: :does_not_build

  depends_on "pkg-config" => :build
  depends_on "cython"
  depends_on "glfw"
  depends_on "gtk+3"
  depends_on "libepoxy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  # Fix for parallel cythonize
  # It just put setup call in `if __name__ == '__main__'` block
  patch :p0, :DATA

  def install
    python = "python3.11"
    ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python)

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
