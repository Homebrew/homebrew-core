class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.4.tar.xz"
  sha256 "d0fdb24f93b6d889f309d2f526b8ea9577e0084ff0a62b4623ef1aed52e85a1b"
  revision 1

  bottle do
    cellar :any
    sha256 "56c0b40edc95e09d9dd1c57d27a45267a9f86a1e3623eb94137c3b78bc226a5b" => :mojave
    sha256 "89f662099926f9fa540f3d8a89469589bf354dbaf0410adc83a19e9553ede19b" => :high_sierra
    sha256 "99d9576a745ff5fc7818a21bb0ca22232c8cc2a481693105921dd1d9292f30eb" => :sierra
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
