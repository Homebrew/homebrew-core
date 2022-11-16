class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.2.tar.xz"
  sha256 "ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_ventura:  "032efc90710d1ab36d5bf7aa8612126c5d862f5b5e9ae816dabaf40aeb8bd874"
    sha256 cellar: :any, arm64_monterey: "24cba48d68641e43c07899d486d8b7e9bbdb8d4f1a23843e48ef328b09b5b647"
    sha256 cellar: :any, arm64_big_sur:  "0edaaf1ea51ce8edb6370da3387d54d664a0f6a3359fac8f202f1bf81f14944e"
    sha256 cellar: :any, ventura:        "855b43092e003be963c44dee252c116851aef666cbbc34d52a83195e771df2e6"
    sha256 cellar: :any, monterey:       "6ba0aab7c1044eabaf82a14cd09b602f7713d863c5856284dc144ad4bf89ae74"
    sha256 cellar: :any, big_sur:        "d926d5032ba049197ec493848e800061b7f974f11df90f9a03054292676e0b67"
    sha256 cellar: :any, catalina:       "8440c7e5623f3a4a9c6f296a905a6f864ad9c61e85e8ed0ff1ef0a015ff6a37e"
    sha256               x86_64_linux:   "46dea53b67a21df6da9b2ba8a5b780b5c7bb9f68c4d9e4531e0d3d8d679f54cd"
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
