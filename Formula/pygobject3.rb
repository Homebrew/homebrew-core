class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.1.tar.xz"
  sha256 "42312b4a5015571fa0a4f2d201005da46b71c251ea2625bc95702d071c4ff895"

  bottle do
    cellar :any
    sha256 "47f0f9ee085b4028529cc08ed46914093b29725b03cd8a8e3abc612b034ec596" => :high_sierra
    sha256 "beb4494d3eba9baac676418d6467572d77c4c22a1f0edc9d93443463d42aa66d" => :sierra
    sha256 "de1ced9995f352c09780fdddf7bebf00aea13acfc8222aeccc3e2e144dbdd2f1" => :el_capitan
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
