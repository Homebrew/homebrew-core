class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.50/pygobject-3.50.0.tar.xz"
  sha256 "8d836e75b5a881d457ee1622cae4a32bcdba28a0ba562193adb3bbb472472212"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "795deab77b4e616f164998005f68fed69bbd7a4a737aed2da8962fca78f1998a"
    sha256 cellar: :any, arm64_sonoma:   "a05bdf08604e6ff3b46acf5c3fe0b6f4cfa078cf39546cd6707d47dcd5d45444"
    sha256 cellar: :any, arm64_ventura:  "c836989426c7f07dc41aa74bbe40190f82a3afa3fdda86b9425e6e8c540b90cf"
    sha256 cellar: :any, arm64_monterey: "6f31ebad4163c3d6dd8521a530213ab42af7ce1540c8b100be6bc2e1e1537eba"
    sha256 cellar: :any, sonoma:         "c876cfa95857d59a75d35c7977d20c5625c8a9373bf9fb44baa008e23d182a83"
    sha256 cellar: :any, ventura:        "30c7b2945bb444c020a7b04f16cd4440143a1fdbe1e0473e9c64df1fd8d7784f"
    sha256 cellar: :any, monterey:       "3a66f0a3fc77a0836f9413ede8c2019f586c1ce220f29f888e52a2476914e114"
    sha256               x86_64_linux:   "a9a30f9517916827435fd0728537c556146283271ceeae7bd02cd49c8907c096"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")
      site_packages = prefix/Language::Python.site_packages(python)

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages}",
                                         "-Dpython.purelibdir=#{site_packages}",
                                         "-Dtests=false",
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
