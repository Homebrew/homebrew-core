class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.16.0.tar.xz"
  sha256 "55dc7aaed1855565f9b9ef842d93e93bfc5cb2b376faef6af5b463e1774e2d38"

  bottle do
    cellar :any
    sha256 "abdd01bbce6825ff606f081afed46c9336bd8111a823de2ff996facabab08084" => :mojave
    sha256 "f70c8f3ce2ca28e53b656be45f2b6b44a5571c766be934fc1721023e1c7e262d" => :high_sierra
    sha256 "17a78814a48272ec9bfe41d8248fb804d4b2aabe82f9f8d3e59d35b50dac14aa" => :sierra
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
