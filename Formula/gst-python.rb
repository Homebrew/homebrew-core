class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.14.4.tar.xz"
  sha256 "d0fdb24f93b6d889f309d2f526b8ea9577e0084ff0a62b4623ef1aed52e85a1b"

  bottle do
    sha256 "c45fb36e4e3bc890901bef8d695afc8185359f7465672ad6cbc440204b3adc98" => :mojave
    sha256 "9b6830252dd7c90a8def4565c8e13b5a82a2b325cc3ef04ca44b46331bb9c7b8" => :high_sierra
    sha256 "e46542b7762d896f51aa74f02393c4b82904d91a4ba8e5d6c7902031d20e4281" => :sierra
    sha256 "b9a55ab56c0b17a2c60473b896ea34264faffe803eb4191d1ceeaedca69b2298" => :el_capitan
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
