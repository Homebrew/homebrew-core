class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.1.tar.xz"
  sha256 "1f34b5f7624de35e44eb5a7eb428353285bd03004d55131a5f7f7fa9b90f3cc9"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "cc6146ded560fed861495e2d391ff020e3dbdb2770a37f3ca5397d76eed3d486"
    sha256 cellar: :any, arm64_big_sur:  "88410c89464f0457a1dc5f4ea32a08408a5b52d93edd945502092d07f8723422"
    sha256 cellar: :any, monterey:       "2135f6b89d37a195ed7be2274d14f97eddd571ec65845ec3c73d514fedc90a6a"
    sha256 cellar: :any, big_sur:        "ba2ac31f849aecca2066c1784da49b06fbf3774f75aeff0a2f571c8a59cde85b"
    sha256 cellar: :any, catalina:       "76196498d8d38fefe0cf56baa75267e6b0e7d50c33223d8d17143bb252fb8ce1"
    sha256               x86_64_linux:   "3e4f43aa67122799302aafd35c5c36874d8291481b792752bd7ba80bc808a918"
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
