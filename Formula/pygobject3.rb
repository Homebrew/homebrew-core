class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.24/pygobject-3.24.1.tar.xz"
  sha256 "a628a95aa0909e13fb08230b1b98fc48adef10b220932f76d62f6821b3fdbffd"

  bottle do
    cellar :any
    sha256 "d0767e8408bc2575f0205e8944fc1b3b29ede42cb11cdfc4c938136908a18f30" => :sierra
    sha256 "ac6f1745ef2e9c3fe91c73d20dc9f2e988e3a5f0809efa873c4fcc053bc0dfda" => :el_capitan
    sha256 "74c2468d44d6b9c70aa0c4e922ef5a8357ddc89d5559322b39485b141c5512df" => :yosemite
  end

  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
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
