class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.0.tar.xz"
  sha256 "9b12616e32cfc792f9dc841d9c472a41a35b85ba67d3a6eb427e307a6fe4367b"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "a5589e885345d3680de0c7f4a93fb13940bb2ccb3615bcc28ecf98e8edf72f70"
    sha256 cellar: :any, arm64_big_sur:  "435f6c7f01bcba010ceb53edf6ca9df8a31fffebf239d91a217e38d823c6f3fa"
    sha256 cellar: :any, monterey:       "0de11a74ba9e4783a5009ed99fc0939b69a48490b60c15ecdd73eeffae1da3d6"
    sha256 cellar: :any, big_sur:        "f9f1c60b23478993fc7ad3df87314c44dd172bcce440c4fccaf4222849834541"
    sha256 cellar: :any, catalina:       "44bee3904b07d3e6bf3866e0e4de6ed4f4bfb0641a781e132a6d2c52de38332c"
    sha256 cellar: :any, mojave:         "1d4bdcfee7b2dac4300170e7f9cb5d94ae27b35b7127e5f7d9972b89f9130dfc"
    sha256               x86_64_linux:   "a34ce5794cfd73a3ac9864260aec1525b96967b9859a19286a884270b35afede"
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
