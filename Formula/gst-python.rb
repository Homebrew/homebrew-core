class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.16.2.tar.xz"
  sha256 "208df3148d73d9f416d016564737585d8ea763d91201732d44b5fe688c6288a8"
  revision 1

  bottle do
    cellar :any
    sha256 "fd764334bec11aca9e91e0c2d8f59f08f3ea0bf0022c377b7013804fdca20062" => :catalina
    sha256 "7142cb296ec3244e40362698f2a89d988070b23afe84696111ee0696d6f2859b" => :mojave
    sha256 "edcacd16e3a9cd57bc0395f10f2be461efe98cb0ae304ed7c4d09b37dfa4595b" => :high_sierra
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
