class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.3.tar.xz"
  sha256 "4fc3e76c965384e54fb6be819d606ab304988eb677cf0c5dcc0dd555e3ad8307"

  bottle do
    sha256 "374dc4679f41d2cd28ac4c66e7a44724a12d239071174dd6c8d105fddd5f35a6" => :mojave
    sha256 "b8c2e02553b454040b965c5e40b3c634a1d3861b689fed011d8baedc18ccdaea" => :high_sierra
    sha256 "ed0da2e642e6b9c67b4985fe4a8552e0ff8b40c68cb44c2ad42f5a0b065031e7" => :sierra
    sha256 "89e380ff6173e59b29442cb558b8849499ae64c15375087fb49fd4c7abe5cf7f" => :el_capitan
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python" => :recommended
  depends_on "pygobject3" if build.with? "python"
  depends_on "python@2" => :optional
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
