class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.16.2.tar.xz"
  sha256 "208df3148d73d9f416d016564737585d8ea763d91201732d44b5fe688c6288a8"
  revision 1

  bottle do
    cellar :any
    sha256 "c81ba537e1ffcf118f451c9bfd14316130b6fef8c4783200cab52a6b5eb494f9" => :catalina
    sha256 "baccf8cd73d36aba4ce9418639c70c15c48b1675a3bf4b8629cc6814f4014678" => :mojave
    sha256 "4f97f255287bcefc62d520f4c29111c3ec1012a582cc5251c00779c29b8a4a02" => :high_sierra
  end

  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.8"

  def install
    python_version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    # pygi-overrides-dir switch ensures files don't break out of sandbox.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pygi-overrides-dir=#{lib}/python#{python_version}/site-packages/gi/overrides",
                          "PYTHON=#{Formula["python@3.8"].opt_bin}/python3",
                          "LDFLAGS=-undefined dynamic_lookup"
    system "make", "install"
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
