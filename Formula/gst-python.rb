class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.0.tar.xz"
  sha256 "e0b98111150aa3fcdeb6e228cd770995fbdaa8586fc02ec9b3273d4ae83399e6"
  revision 2

  bottle do
    sha256 "9544d0be8252c0199884f7a327710bf891369ffe5ab153493f92623bcad5a870" => :high_sierra
    sha256 "b0adaefeaadac19768117c34698d7ce676296820505cfdee83d4d0cc02e4ce10" => :sierra
    sha256 "97edb68319984a8383a4c68ae617aa275f9bc3268c321742c13eb62eac163f88" => :el_capitan
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python@2" => :optional if MacOS.version <= :snow_leopard
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
