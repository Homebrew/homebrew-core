class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.18.3.tar.xz"
  sha256 "4e630735276e08ff4d70337aa5d91fd008e5f1ed3dc0993674cd5820e264259a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "0323f7f77b31d549d64768a94bae8d8b5b1bb32cb30363e027e77ff40a3691c1" => :big_sur
    sha256 "744cd20c663082002163044a3dc968b6a9230eadabb5b8c531cb06071c3efbc8" => :catalina
    sha256 "0d9a4ce411145a61dbc9ae7d72664ffc437a4281916a1c6f957ea6fdb15bd38a" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.9"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.patch"
    sha256 "ad63ba452d97da70601854cc8e46e8bd53db708a3d98bf7411483d52aadcebf3"
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
