class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.5.tar.xz"
  sha256 "27487652318659cfd7dc42784b713c78d29cc7a7df4fb397134c8c125f65e3b2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "73f7fbdf9d81c21a7a510b2a48468dd43f8bf5ef83fb4d9214a0371fb9df3daf"
    sha256 arm64_monterey: "507f2bc2a38e1703eadff87c0ef62137122992b42f0353290a183e3d8b7274d9"
    sha256 arm64_big_sur:  "1b8eee708cb5ebd7593676fc363caf347285f61f11b7a28aab6ddc4177e51c5d"
    sha256 ventura:        "6ef8dc182ea5e05942028a0064c8537a52682a6256dee8fd25da35c815524a43"
    sha256 monterey:       "7f62d747a6c1923ad2f838682eadfbbd4e6abe3bed9818d2a2bb0159d7929168"
    sha256 big_sur:        "62579fb7951f823f0dddbb6f4a79262ea7039153ff1918826c27080f66ad4422"
    sha256 x86_64_linux:   "4794069a94e3f736f21c22aec9765eda2af3ea9ab129c9da4063022647c8994b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.11"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.diff"
    sha256 "d6522bb29f1894d3d426ee6c262a18669b0759bd084a6d2a2ea1ba0612a80068"
  end

  def python3
    which("python3.11")
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    system "meson", "setup", "build", "-Dpygi-overrides-dir=#{site_packages}/gi/overrides",
                                      "-Dpython=#{python3}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
