class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.1.tar.xz"
  sha256 "ba6cd59faa3db3981d8c6982351c239d823c0b8e80b1acf58d2997b050289422"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a22ba5e1cba6775a21b2cbe9f26981d283d1227888b7802523f4c53a8be72d21"
    sha256 arm64_big_sur:  "27bae7437b43b5531603ef2607ab7c25746dd939f890b97597dd56f91743ef5c"
    sha256 monterey:       "19c0d5b057b0dfbdc9e5e07837f6cb8ef777245776064cb7a346434d4b4149c2"
    sha256 big_sur:        "73bacb36b04c37f84765dead142c6942d53b43803904972e798b21756d6d8e66"
    sha256 catalina:       "479c059af1957f7bab804735736196f3aa7faa6bd7f3165849da05ba7db7e838"
    sha256 x86_64_linux:   "f2c59d74f4cd89c86d89f2f6779c459b10b5ab2786b261515caa112d639f99c5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.9"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.diff"
    sha256 "d6522bb29f1894d3d426ee6c262a18669b0759bd084a6d2a2ea1ba0612a80068"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
