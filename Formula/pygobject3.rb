class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.4.tar.xz"
  sha256 "2dc1a1a444b82955e65b81c2a2511ecf8032404beba4ef1d48144168f2f64c43"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b2e5a251c6d41ad8b039ea1637c39aabbfa3e055366124c7461f65711e210b68" => :mojave
    sha256 "4ac894ae8761c85bceade1626bd4c7afd1850ad8fceb32cbe2a6a852121a2661" => :high_sierra
    sha256 "b5494a628c4b090acc17a6f7510672ed8e1c9487261bffd386368d1c93f23012" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "python"
  depends_on "python@2"

  def install
    mkdir "buildpy2" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python2.7",
                      ".."
      system "ninja", "-v"
      system "ninja", "install"
    end

    mkdir "buildpy3" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python3",
                      ".."
      system "ninja", "-v"
      system "ninja", "install"
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
