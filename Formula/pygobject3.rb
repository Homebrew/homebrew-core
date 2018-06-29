class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.3.tar.xz"
  sha256 "3dd3e21015d06e00482ea665fc1733b77e754a6ab656a5db5d7f7bfaf31ad0b0"
  revision 1

  bottle do
    cellar :any
    sha256 "94fae679989e058565619b7ad90481efe90512ccf90835c823aa35be1d0f379f" => :high_sierra
    sha256 "9165eaa64cd2297ad9bda941521634049ca5ab17e5427970348a3b92af034125" => :sierra
    sha256 "b5af9da841a2fce3722475c17b3b96e271a2a027bbd2a93dfd256895632e0f1d" => :el_capitan
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  depends_on "py2cairo" if build.with? "python@2"
  depends_on "py3cairo" if build.with? "python"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
