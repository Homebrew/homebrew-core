class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.0.tar.xz"
  sha256 "e0b98111150aa3fcdeb6e228cd770995fbdaa8586fc02ec9b3273d4ae83399e6"

  bottle do
    sha256 "22148db36381f8397d5699b4f982b37492bfd7d69c3aa99f14b13ed6773cd3d7" => :high_sierra
    sha256 "b28de98f6dcbd3d7ddf7e7eb388051fba1c8135c815e08d4174ee0702b2c1f78" => :sierra
    sha256 "30be05c62b3341ce6ebbb5fc04dfa8fce724e483d1111214cb02353f09804502" => :el_capitan
  end

  option "with-python", "Build with python 3 support"
  option "without-python@2", "Build without python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional

  depends_on "pygobject3" if build.with? "python@2"
  depends_on "pygobject3" => "with-python" if build.with? "python"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    if build.with?("python") && build.with?("python@2")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "You must pass both --with-python and --without-python@2 for python 3 support"
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
