class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.58/pygobject-3.58.1.tar.gz"
  sha256 "4c80598ade17fbaa7798e01a25d0bf29ce109740786026a074c5c62bb3e79d23"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cca83b04f8a52af9170b2760a68fb79451e91575fa282cbcc411f1a76b062be5"
    sha256 cellar: :any, arm64_tahoe:       "5cbf0e81e7a640d252750b4ec68d88576b4db40d68b43f670cdf55ea083a5991"
    sha256 cellar: :any, arm64_sequoia:     "439f8bf0ac8846dcd7732f01329f6ec579065c83a7c8ac4e121b64593acff586"
    sha256 cellar: :any, arm64_linux:       "beb4512e787416ca0951d53b60926690dafc5405db8b73a91de7f9e35140130c"
    sha256 cellar: :any, x86_64_linux:      "6e3682a80ea3584c1bfde8c9f5c8d45cdef7f14b9916866b96b2e3b3b542e155"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]

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
    Pathname("test.py").write <<~PYTHON
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    PYTHON

    pythons.each do |python|
      system python, "test.py"
    end
  end
end
