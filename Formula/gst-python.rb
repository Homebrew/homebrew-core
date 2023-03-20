class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.22.0.tar.xz"
  sha256 "6c63ad364ca4617eb2cbb3975ab26c66760eb3c7a6adf5be69f99c11e21ef3a5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "627f61e862103cfd5d37f3f8d362486c8f130681bd3803021f5ba7405eda733f"
    sha256 arm64_monterey: "ec8f6d3ca790262c049df58b4d703e22cfd7b50fbc50290c99ef09893f30d1cf"
    sha256 arm64_big_sur:  "f70c45aa848b1caf06d6579557e33b5b4795b0f1c7473d014fbd06d9ad5fe779"
    sha256 ventura:        "b4ca5abcc0e8f24e1c05d7c907bdb979e3d195e0e778bd83203b84e182b5704a"
    sha256 monterey:       "37cbf8dae7e320e4eeee532a197713cd10d1bddf29a29c2655b333534ef1b2d8"
    sha256 big_sur:        "8f81a557d990a051ab91909ecce271a8a80de6f832ef06e3fdefb09d35195f43"
    sha256 x86_64_linux:   "eeac212bb8c9b0b172117c32ff51362a70c280698b5f6baddebc074463425130"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.11"

  # Avoid overlinking
  patch :DATA

  def python3
    which("python3.11")
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    system "meson", "setup", "build", "-Dpygi-overrides-dir=#{site_packages}/gi/overrides",
                                      "-Dpython=#{python3}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
__END__
diff --git a/gi/overrides/meson.build b/gi/overrides/meson.build
index 5977ee3..1b399af 100644
--- a/gi/overrides/meson.build
+++ b/gi/overrides/meson.build
@@ -3,13 +3,20 @@ install_data(pysources,
     install_dir: pygi_override_dir,
     install_tag: 'python-runtime')
 
+# avoid overlinking
+if host_machine.system() == 'windows'
+    python_ext_dep = python_dep
+else
+    python_ext_dep = python_dep.partial_dependency(compile_args: true)
+endif
+
 gstpython = python.extension_module('_gi_gst',
     sources: ['gstmodule.c'],
     install: true,
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep, python_dep, pygobject_dep])
+    dependencies : [gst_dep, python_ext_dep, pygobject_dep])
 
 env = environment()
 env.prepend('_GI_OVERRIDES_PATH', [
