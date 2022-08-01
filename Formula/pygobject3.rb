class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.2.tar.xz"
  sha256 "ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8421dca7ad4ca708e794833f7d52900d242c69f7dedb68293d092ec8ad2825f7"
    sha256 cellar: :any, arm64_big_sur:  "b23869dc59112723ab755d023f95afd23e43b7e3425a4d085f98d45d3801e4c8"
    sha256 cellar: :any, monterey:       "28e41e2bf7690f4597591c86ba4d1e46b8642641a277e60816e626aa93ba1d31"
    sha256 cellar: :any, big_sur:        "52cef1bf5868f1453e5a1ec6e9c992decb6f0ec0ecf08aeac71cca101572cd62"
    sha256 cellar: :any, catalina:       "9c177f39360eb011c208fec4ec24d8e109a2f06fd03b67ec9c61e96e5c2c201c"
    sha256               x86_64_linux:   "864f5bf405ab0834ce79c09c977718d9b16286b55219014f48d47118243c3633"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      mkdir "buildpy3" do
        system "meson", *std_meson_args,
                        "-Dpycairo=enabled",
                        "-Dpython=#{python}",
                        "-Dpython.platlibdir=#{site_packages(python)}",
                        "-Dpython.purelibdir=#{site_packages(python)}",
                        ".."
        system "ninja", "-v"
        system "ninja", "install", "-v"
      end
      rm_rf "buildpy3"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pythons.each do |python|
      ENV.prepend_path "PYTHONPATH", site_packages(python)
      system python, "test.py"
    end
  end
end
