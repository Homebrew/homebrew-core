class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.1.tar.xz"
  sha256 "f5577b9b9c70cabb9a60d81b855d488b767c66f867432e7fb64aa7269b04d1a9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9bada550c6806e5f89394a760bd35614de8210490f5c788aa5ff8dacf4393247" => :high_sierra
    sha256 "2a44945bb6d8c0f58856b1812c4e8a2232341ab022d433ea6734e742587894e3" => :sierra
    sha256 "dfff2dc9f1e74b0320cf53e11966c84a5b54136d51874f2b3563ef5be031ccaf" => :el_capitan
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "python" => :optional
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
