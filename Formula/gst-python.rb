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
    rebuild 1
    sha256 arm64_ventura:  "6160154235951d7ff14e28b5b2e63ca46ad4c67cefb85878ec9f3235bd7dc353"
    sha256 arm64_monterey: "f232d6369ff3182389abd14345eec7dd50e49c90666461f35e5bd34d1365fcef"
    sha256 arm64_big_sur:  "6732658419661fa5e5eaa10f411c3200d26bc5b3717a6c69c5ec4c1e8619fd73"
    sha256 ventura:        "9102414169ed31f48f8c0e3741ffa44760c411608f409dd094c728f1aa65dfe7"
    sha256 monterey:       "7f5bbb9496be22f10fda37b1534f97cbd2f9b0a29a5681fd6d47661f7e3b28f4"
    sha256 big_sur:        "7e9fbc50c5cc07f273dbe3a5a57c59e99dc50f58dd20d8fbb41c87da0c8828ce"
    sha256 x86_64_linux:   "5dc205d0d1778992ca8ff8eacd08af2441fc78588cde6e0b3e94f9f06ee5e9f6"
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
