class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.2.tar.xz"
  sha256 "ac443afd14fcb9ff5744b65d6e2b380e70510278404fb8684a9b9fb089e6f2ca"

  bottle do
    cellar :any
    sha256 "40f262ce96d07a14e9e7949d42b9dda053203ce6ab5d5e16fa4fa6543dd8908c" => :high_sierra
    sha256 "09e59b39dec8b7e44a6f3a74fe14c1c6ad06a5b879b0d936ba1478a766909564" => :sierra
    sha256 "08a11bcd044482d90ce0b7482e5be7bd967e580e6224d85d39bb02e64f6a9906" => :el_capitan
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
