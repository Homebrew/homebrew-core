class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.0.tar.xz"
  sha256 "42b47b261b45aedfc77e02e3c90a01cd74d6f86c3273c1860a054d531d606e5a"

  bottle do
    cellar :any
    sha256 "9c3919e498311f4612da3cf6e6191d85daff93105fb3fb4edfcfc18a10c7a3d6" => :high_sierra
    sha256 "3895e5625ff5e46f35c340bbc3ef7af4af7beffdd70f4ff40e1ffc8bcf1b18e7" => :sierra
    sha256 "039002346834702f8a0a049f20862b7cbb310e65af3b11f92e12815942d225d9" => :el_capitan
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
