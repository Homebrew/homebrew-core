class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.10.0.tar.xz"
  sha256 "de59b493e47bf0221421873f6c80811dd7ff7b1929521264d3a559bc410dc741"

  bottle do
    sha256 "2a32138a13b2ce91eb8b5f79939509c3b87c6232e72609096361b40dd65b67dd" => :sierra
    sha256 "819a8c043b9a5793e4c32b8f6b9a63d8b551c20292406df72b666e6fd832b179" => :el_capitan
    sha256 "31a0f41cdbe7c5a7f1cc8d75f6a1ce54ecd2bf4cead5658af129a11127f7a1ac" => :yosemite
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
