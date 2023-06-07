class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.44/pygobject-3.44.1.tar.xz"
  sha256 "3c6805d1321be90cc32e648215a562430e0d3d6edcda8f4c5e7a9daffcad5710"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "370d24f45caf90e69b19ec1f44449adaba007ae77daff824f42afa342b664986"
    sha256 cellar: :any, arm64_monterey: "8b79722c80c7f47cda8be7574d11e175a21eb38408d3a781c6ff1422870c4768"
    sha256 cellar: :any, arm64_big_sur:  "e35223a5803615e6e2b8e1d331a0e2c5c4b2d60596d2a338a578dbdeb543add6"
    sha256 cellar: :any, ventura:        "44c25386ff91ca3358a26d4262353d7af36864ae848eec12ca63d639cfaffad7"
    sha256 cellar: :any, monterey:       "4d8039bdbc683872d9a053d414c8073ffff9de4b997478d77928efbe0acb5a7d"
    sha256 cellar: :any, big_sur:        "a23536b141c8a9b2ec56baf959448aa1a61fd82e10db2c0c2a2e471bd51f55d8"
    sha256               x86_64_linux:   "312dff876344160d22f3ba86f57a1c2587bf5a290155b66480b2083fb52f35be"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         *std_meson_args

      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
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
      system python, "test.py"
    end
  end
end
