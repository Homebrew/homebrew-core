class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.2.tar.xz"
  sha256 "dc40be5ab4f1a433ff3f0af2b3d2d79a363009020c41ec10f9747ba64200cb22"

  bottle do
    sha256 "b8c2e02553b454040b965c5e40b3c634a1d3861b689fed011d8baedc18ccdaea" => :high_sierra
    sha256 "ed0da2e642e6b9c67b4985fe4a8552e0ff8b40c68cb44c2ad42f5a0b065031e7" => :sierra
    sha256 "89e380ff6173e59b29442cb558b8849499ae64c15375087fb49fd4c7abe5cf7f" => :el_capitan
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python@2" => :optional
  depends_on "python" => :recommended

  depends_on "pygobject3" if build.with? "python"
  depends_on "pygobject3" => "with-python@2" if build.with? "python@2"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    if build.with?("python") && build.with?("python@2")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "You must pass both --without-python and --with-python@2 for python 2 support"
    end

    Language::Python.each_python(build) do |python, version|
      # pygi-overrides-dir switch ensures files don't break out of sandbox.
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--with-pygi-overrides-dir=#{lib}/python#{version}/site-packages/gi/overrides",
                            "PYTHON=#{python}"
      system "make", "install"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
    Language::Python.each_python(build) do |python, _version|
      # Without gst-python raises "TypeError: object() takes no parameters"
      system python, "-c", <<~EOS
        import gi
        gi.require_version('Gst', '1.0')
        from gi.repository import Gst
        print (Gst.Fraction(num=3, denom=5))
      EOS
    end
  end
end
