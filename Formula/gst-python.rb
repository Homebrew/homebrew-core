class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.0.tar.xz"
  sha256 "e0b98111150aa3fcdeb6e228cd770995fbdaa8586fc02ec9b3273d4ae83399e6"
  revision 1

  bottle do
    sha256 "a196fc470d57c55e80a68c5e76c8dc99479c173f9766b83b9df6ea02aa4a5e05" => :high_sierra
    sha256 "fdf9bf9f7c97eafd5182e5c46f90013527a80a5b5a54139d93188748b582f377" => :sierra
    sha256 "3a561a608a5d284cb4403ef50c494779127cd474a7fe9aaad147cea9b83e7d7e" => :el_capitan
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
