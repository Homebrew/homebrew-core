class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.22/pygobject-3.22.0.tar.xz"
  sha256 "08b29cfb08efc80f7a8630a2734dec65a99c1b59f1e5771c671d2e4ed8a5cbe7"

  bottle do
    cellar :any
    sha256 "50b65d122993af6a29aa5c4a658f8dc4fb2d7ff6b557248043550dff69bff643" => :sierra
    sha256 "ab749908e5675d75b8709e711f56d51f5747b4d5242b847b4ede481ab681b7d2" => :el_capitan
    sha256 "dd5e3f9c4c01bd6633635d3189f6ca3af9af81c1c302de8df22414e067252ee0" => :yosemite
  end

  option :universal
  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?

    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end
