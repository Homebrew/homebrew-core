class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.1.tar.xz"
  sha256 "42312b4a5015571fa0a4f2d201005da46b71c251ea2625bc95702d071c4ff895"
  revision 1

  bottle do
    cellar :any
    sha256 "56461996e7c18d101a9bf0f73c0af69a3a364c87d53779b5b386c7b45500b7b2" => :high_sierra
    sha256 "b7a79b0784ffce3b7bdb1f6d699197d09818bf0985efd5ac8576f522183b8bf7" => :sierra
    sha256 "5c41e7c2436528ed303d352e6adf13e33414bf81e00896e1757c925774a1b3bc" => :el_capitan
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "python@2" => :optional if MacOS.version <= :snow_leopard
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
