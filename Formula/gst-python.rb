class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.8.3.tar.xz"
  sha256 "149e7b9c2c361832bc765d39bce004d1ffe1b330c09c42dc902ca48867e804ce"

  bottle do
    sha256 "3c72b68dd7532e979adb3142dfa3ba4890929206a57c79f67a045f02ce28420e" => :el_capitan
    sha256 "fab0fee62ff6767febb48a14c652f5a66229c23d730d7565eba4e177b2db215e" => :yosemite
    sha256 "da74c98301daf282b9cbd1de8cbe2cf69911ca09820779bbc23cbe8b08dccc67" => :mavericks
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
