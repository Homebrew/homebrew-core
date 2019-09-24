class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.16.1.tar.xz"
  sha256 "b469c8955126f41b8ce0bf689b7029f182cd305f422b3a8df35b780bd8347489"

  bottle do
    cellar :any
    sha256 "3c01256256633e213ed88caa8067b01d71bc7a4d1b71face8453cefc927ebfd7" => :mojave
    sha256 "5dbda1bf3a3fdd4b01ab87c64a7cd32485ede364627e0e8bcce1b7cc0e5338be" => :high_sierra
    sha256 "f45160f9d7be6b81b1fa9f6f603bc6c2dcbb32232975136890ab10b72f7eb704" => :sierra
  end

  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python"

  def install
    python_version = Language::Python.major_minor_version("python3")
    # pygi-overrides-dir switch ensures files don't break out of sandbox.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pygi-overrides-dir=#{lib}/python#{python_version}/site-packages/gi/overrides",
                          "PYTHON=python3"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
    # Without gst-python raises "TypeError: object() takes no parameters"
    system "python3", "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
