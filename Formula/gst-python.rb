class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.12.4.tar.xz"
  sha256 "20ce6af6615c9a440c1928c31259a78226516d06bf1a65f888c6d109826fa3ea"
  revision 1

  bottle do
    sha256 "5cf13113a7c9dc5dbdff5c8d59825cd563a10cbe628f50aae4d532b92f40c6ba" => :high_sierra
    sha256 "c38b27c2e2cd95473bdf2357ee47a9ac86868de78cdd0969f1e73d7cd4503fd4" => :sierra
    sha256 "687890effb7ae3b3702e5d3f837b7eb06caff9ae7c5116ea2904495bf094e1fe" => :el_capitan
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
