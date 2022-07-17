class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.2.tar.xz"
  sha256 "ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2465ae207fb2155cc8a5fe122c847fbd031c9f43b96fb4fffd7cf1b410fc85ca"
    sha256 cellar: :any, arm64_big_sur:  "95f59a12a61b4bc44be0c2a5a1f39a13bc3e6e84f1f35408139a6bbcb93ac5d0"
    sha256 cellar: :any, monterey:       "a2d5de03368275330c586fd0150db073fdea0566bce46b775f44bcfc5cf62e61"
    sha256 cellar: :any, big_sur:        "0f8b624630acb580681797ec88084af4cc7ae835a5028968a390927ae5fb40f9"
    sha256 cellar: :any, catalina:       "aef0695f07cfba7bd9400ceab30259f63b6493ec6c1f25313db43f26ded3da5e"
    sha256               x86_64_linux:   "13966903d4f41f29424d8a19cad91191a196db63df832aa890c47723b6b48a4b"
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
