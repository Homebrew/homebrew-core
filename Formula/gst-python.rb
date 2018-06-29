class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.1.tar.xz"
  sha256 "1bc6704955e343f78d2d935487f26d2db4c131c9a6dad38eb331c7e3639147d3"
  revision 1

  bottle do
    sha256 "0b377b1ecd37157adc36e8c66dab678f5cf8d5f3ad48a372eee8ab01982f7f43" => :high_sierra
    sha256 "f2f32d7bd466279c708a1dcb9eae1f6fca7c4d16a4cf4bfca0320a35df03a959" => :sierra
    sha256 "d2ed501a54f497e76081fd1db8e11951d73d94ef92764a40e0cbac7fc9a5a69e" => :el_capitan
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python@2" => :optional
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
