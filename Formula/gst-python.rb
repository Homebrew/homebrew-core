class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.0.tar.xz"
  sha256 "8f67bdc5606ba33606c6bc896e89de7dcd8cf4fca459f71389b1b6fe075b5e54"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "30a5860917c2089c5de5144ff6dc54628392413960bb62b33b2ff0ce8d0f428f"
    sha256 arm64_big_sur:  "58570611a51759670c91d3f019df6c2409e88a31cc3b42d671bfda6430e2ff47"
    sha256 monterey:       "c4b55a7de7a5016e08d524f603ce1562034fa7506ad6025ee30d0cf014b41e98"
    sha256 big_sur:        "21f3ef42b44ecce8bd36ef823c7b0280f207f84e60764cce0ffd7f455266bd93"
    sha256 catalina:       "6c24cbaf51a4e4faf3bbbf5daf4a6da584679125fc127770efd8e726d4881895"
    sha256 x86_64_linux:   "7c1b9be91a791992c0310b74e7024611fbf3818daa1636f343f365bde2d1767a"
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
