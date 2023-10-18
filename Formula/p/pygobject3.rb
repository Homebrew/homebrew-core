class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.46/pygobject-3.46.0.tar.xz"
  sha256 "426008b2dad548c9af1c7b03b59df0440fde5c33f38fb5406b103a43d653cafc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d966b22fcc02c79021526432ebc551d759391bc56e6a549bc6c19562da881925"
    sha256 cellar: :any, arm64_ventura:  "753aa7bb341bdf7d86175bbaf0517efa2782ff01b72e47589ca6941fc9cfb7e9"
    sha256 cellar: :any, arm64_monterey: "ba7a1a0adbfa956c44ee9f91918942d6dd4f1e2a48252d7db665fb92c2d888f2"
    sha256 cellar: :any, arm64_big_sur:  "ebd45a21cb9738bd37fea9dbb1275fef65772e674f23779475bbbe56270e797f"
    sha256 cellar: :any, sonoma:         "f3862d795fff79616ff37cde3d7c251d4b73418709c6c846ab48161ee9019f6d"
    sha256 cellar: :any, ventura:        "6186edc561f0a9e4a5abc967cdf4ecfa19ea08f33e454bf01a042789904b8d11"
    sha256 cellar: :any, monterey:       "d671097f271a950109eeee539e2d7d1d199eaf00a67337cbb982e6befdd7986c"
    sha256 cellar: :any, big_sur:        "826f450d3b316fe03610394af7e0f6bf3278454da0029487f93f3169f8e67adb"
    sha256               x86_64_linux:   "9db8d5022e6f7831e85c81a13fd6143fc3d47df8b0dfa12a69f469133ff57200"
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
