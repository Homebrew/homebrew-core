class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.46/pygobject-3.46.0.tar.xz"
  sha256 "426008b2dad548c9af1c7b03b59df0440fde5c33f38fb5406b103a43d653cafc"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "41a80edf2b4820d8a53fd04049ab6d0347848f5279fc55f1881a3c1865cb9096"
    sha256 cellar: :any, arm64_ventura:  "1bfbb1c565ce50261d061a19922e8040d0d95302880b739c898d5b94f8084273"
    sha256 cellar: :any, arm64_monterey: "c1872fab2ffe26c098f69aa0dae3ec4e34e7f31173c696a1a270c07b2a30ee34"
    sha256 cellar: :any, sonoma:         "cc331748f1c83f064f60349b01a5b6bbc2c6d2b078d08e3ad0ac8c9883d7f219"
    sha256 cellar: :any, ventura:        "057e32400d8669586a289e5386efff4a4eefcd118fb2af5b7f62a210b3c2fe88"
    sha256 cellar: :any, monterey:       "472d2dbb1e702f90c192700034c139132238de95150670ba6a8b997b20af1766"
    sha256               x86_64_linux:   "534231a0b12461b68c099f2445f380432f2bb5dfb56841340e18d0aff01fff69"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
