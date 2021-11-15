class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", revision: "5270c34b4c00", using: :hg
  version "634"
  revision 8
  head "https://hg.linkmauve.fr/touhou", using: :hg

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5520302c2a524409c076e4ceefc246f4163480805c664981a02a803f81c21780"
    sha256 cellar: :any,                 arm64_big_sur:  "3a8cd72d8c0a67a8846d8c27a33bd7e3474827f44100b404dfbd71476a053a4c"
    sha256 cellar: :any,                 monterey:       "6f5bcc94ce7ea2d13f6fbc8ca723916197f0c7cd3bdb1a23b0d7650ace9eef5e"
    sha256 cellar: :any,                 big_sur:        "f6cc4df128378963b11dad010097ffc897e195f578afd1cedf83869280748272"
    sha256 cellar: :any,                 catalina:       "68aa26a6209130a0bf44da6716964fcd97cd667daae9c3a600b6a19c33d91951"
    sha256 cellar: :any,                 mojave:         "7ef160097cf7d38842b5ad88403f6c410a9e90e93f4942df3b3019d8d4b9d514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940fe7e5223b33539234119166691f17cf0f7514e1a80a030daa1a452921bc42"
  end

  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "gtk+3"
  depends_on "libepoxy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/a5/1f/c7c5450c60a90ce058b47ecf60bb5be2bfe46f952ed1d3b95d1d677588be/Cython-0.29.13.tar.gz"
    sha256 "c29d069a4a30f472482343c866f7486731ad638ef9af92bfe5fca9c7323d638e"
  end

  # Fix for parallel cythonize
  # It just put setup call in `if __name__ == '__main__'` block
  patch :p0, :DATA

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    resource("Cython").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # hg can't determine revision number (no .hg on the stage)
    inreplace "setup.py", /(version)=.+,$/, "\\1='#{version}',"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    # Set default game path to pkgshare
    inreplace "#{libexec}/bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install Dir[libexec/"bin/*"]
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
    system "#{bin}/pytouhou", "--help"
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
