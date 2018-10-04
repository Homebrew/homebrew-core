class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.4.tar.xz"
  sha256 "d0fdb24f93b6d889f309d2f526b8ea9577e0084ff0a62b4623ef1aed52e85a1b"

  bottle do
    sha256 "4412a3a8077e55aa5b1899ff7a89d726afad1f2142e61e93f91d9d54a0b87fe5" => :mojave
    sha256 "4fe5e40b6897c575602ff3d668bf9408fde1f9fcfea855fcf08067d06401f5ad" => :high_sierra
    sha256 "c6aa1db5ddb24672448b36d1cbf979cfc826fe57b382015bf35b5a5da646c506" => :sierra
  end

  option "without-python", "Build without python 3 support"
  option "with-python@2", "Build with python 2 support"

  depends_on "gst-plugins-base"
  depends_on "python" => :recommended
  depends_on "pygobject3" if build.with? "python"
  depends_on "python@2" => :optional
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
