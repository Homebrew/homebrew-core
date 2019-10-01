class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.16.1.tar.xz"
  sha256 "b469c8955126f41b8ce0bf689b7029f182cd305f422b3a8df35b780bd8347489"

  bottle do
    cellar :any
    sha256 "7f4d90b39aeb4236a2e5b11df72a4afb183e6b6439481ca17e12618ce92fc2b4" => :catalina
    sha256 "62b52f79633253a42abb7741ac1699adfb803be04224b4e4b03853362f15ba37" => :mojave
    sha256 "4e6ae3f15ec2c1faa3918e5bce6081abb8d6c7218bbe88001afd4741a4cced07" => :high_sierra
    sha256 "2f32483af0e0e64beb71e8213744c5a36cbb2353120d69524fc6bf58e505e361" => :sierra
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
