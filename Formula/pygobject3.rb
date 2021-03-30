class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.40/pygobject-3.40.1.tar.xz"
  sha256 "00c6d591f4cb40c335ab1fd3e8c17869ba15cfda54416fe363290af766790035"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "74933227222372963a641ebdfbeafc57dc4b546535e25413004baf9d23230938"
    sha256 cellar: :any, big_sur:       "92cf4015f9e0d6ee9d026bda3d007873ab84d638fae69f6901860f3e81e0d865"
    sha256 cellar: :any, catalina:      "bc062d41e5825c5aa071508691131045090d9b52be133be4740d82569b571b69"
    sha256 cellar: :any, mojave:        "15e27dae7abd17e2f37cbfe8d935a3d9b0104f83ce4ebade95df7fcbd63ceb2c"
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
