class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.38/pygobject-3.38.0.tar.xz"
  sha256 "0372d1bb9122fc19f500a249b1f38c2bb67485000f5887497b4b205b3e7084d5"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "d9eb35a72a4970c2c6c537b7b8938f9147390a2cd4027d33bb119417c5693aa1" => :big_sur
    sha256 "7b65e09a52672b0b31ebeb73308d25adae46baf3d0a7d544da0c3a50617d90c4" => :arm64_big_sur
    sha256 "e4e592579b949b2b7df8cbd3b3956d3ee285054a4c1e3ecfbc9647a4e9bcf24e" => :catalina
    sha256 "6c7132a187cc3cd7885d980b449022ca20d458e1657007000e471234f0504bed" => :mojave
    sha256 "6f26840f9ae7c64ce17121d9ae60690447eb58269099fc96ed488308c755c8ac" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "python@3.9"

  def install
    mkdir "buildpy3" do
      system "meson", *std_meson_args,
                      "-Dpycairo=enabled",
                      "-Dpython=#{Formula["python@3.9"].opt_bin}/python3",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
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

    pyversion = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "test.py"
  end
end
