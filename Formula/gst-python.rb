class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.10.3.tar.xz"
  sha256 "bdfa2d06dfe0ce68f638b04fed6890db506416c1dcf1279e83458269d719a4e8"

  bottle do
    sha256 "5fe74e91fe78d178b2334f037e87c8828cb3cb3a8a26e20f191e17d7e0f15555" => :sierra
    sha256 "253cab8723c02f53fd8e0e1012421dd1fbd1cb588042214cffc62f000d1c9893" => :el_capitan
    sha256 "dbcbbc9b38c5fb42eb9a06c6050eae930fd3190372761be9b0edce951b6e7da1" => :yosemite
  end

  option "without-python", "Build without python 2 support"

  depends_on :python3 => :optional
  depends_on "gst-plugins-base"

  if build.with? "python"
    depends_on "pygobject3"
  end
  if build.with? "python3"
    depends_on "pygobject3" => "with-python3"
  end

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
