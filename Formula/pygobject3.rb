class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.24/pygobject-3.24.1.tar.xz"
  sha256 "a628a95aa0909e13fb08230b1b98fc48adef10b220932f76d62f6821b3fdbffd"

  bottle do
    cellar :any
    sha256 "66741856284cc5db7d9af874c0928a77a02b24393283e1e2c79afd455ea8ac0e" => :sierra
    sha256 "754210bae699dd5b6fb2d5947358a075aa1c1b073aedb501e5c428745abe9a12" => :el_capitan
    sha256 "a24420da59fae5978cefe8caf71270e8113b8643772689617562ca6b8ef30a83" => :yosemite
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
