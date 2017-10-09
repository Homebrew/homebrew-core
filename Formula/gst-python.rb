class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.12.3.tar.xz"
  sha256 "c3f529dec1294633132690806703b80bad5752eff482eaf81f209c2aba012ba7"

  bottle do
    sha256 "12c1cebb7c95bbef113e18aff431196752aea17e4f2703cddd4d41dec7815f64" => :sierra
    sha256 "84c5d8db2b68491504a7325b3b15947a343d3869d0fbdad614ec88f80e840bdd" => :el_capitan
    sha256 "f5cb141a0c2e4ac9ca4bf43cdb2ee583ecda887c4cfe0e583d291fd517077195" => :yosemite
  end

  option "without-python", "Build without python 2 support"

  depends_on :python3 => :optional
  depends_on "gst-plugins-base"

  depends_on "pygobject3" if build.with? "python"
  depends_on "pygobject3" => "with-python3" if build.with? "python3"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    if build.with?("python") && build.with?("python3")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "Options --with-python and --with-python3 are mutually exclusive."
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
      system python, "-c", <<-EOS.undent
        import gi
        gi.require_version('Gst', '1.0')
        from gi.repository import Gst
        print (Gst.Fraction(num=3, denom=5))
        EOS
    end
  end
end
