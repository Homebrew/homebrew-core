class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.10.3.tar.xz"
  sha256 "bdfa2d06dfe0ce68f638b04fed6890db506416c1dcf1279e83458269d719a4e8"

  bottle do
    sha256 "9a4dbe01033e9ab576b0aa48fa598be8e9ad0fa1396450ba367229c0827294c0" => :sierra
    sha256 "4d308cb87ac7ec4877db850f2b904c7c7247a193d983f885aa6c6fde6c18100e" => :el_capitan
    sha256 "8d74ef96bb0c8e25d8a29dd2f43fc7260d503a9842fdcfd020a21c304b6ceb5f" => :yosemite
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
