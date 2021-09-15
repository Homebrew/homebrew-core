class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.40/pygobject-3.40.1.tar.xz"
  sha256 "00c6d591f4cb40c335ab1fd3e8c17869ba15cfda54416fe363290af766790035"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ea716cafcd6905b1f49ad50e9e98a1cceb74be3cb641e8a1e2d670d28cc34103"
    sha256 cellar: :any, big_sur:       "27af5bf268c1c2274d4f97b628b4df0c4fab81c092c8948bf3c6f5e875d6c45b"
    sha256 cellar: :any, catalina:      "e24bd991a052b651a4d7178dd54b4e6a1e25895c3550cb3b3a1e84dfad66ec34"
    sha256 cellar: :any, mojave:        "1a57d5580a83038a20d6256f0aa1398f79510c41eaf402cdbf4bba41a9154591"
    sha256               x86_64_linux:  "87f44a0209b23e685fd8a19a85d76cad5ddfd32e3221c64dc2eaaff3b068c286"
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
