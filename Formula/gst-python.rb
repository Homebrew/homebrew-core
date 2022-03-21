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
    sha256 arm64_monterey: "3030f3cdf609a8c22cf92b3948cd5caa0373aa824640c62ac06555dae947bd8d"
    sha256 arm64_big_sur:  "50ce4bb98ba3f5e2f795463cd5e550aac9f3acf85ac620ce9cb7e521948d246b"
    sha256 monterey:       "d82d67857aaf0a331b3c167a9b8604e825e3e7d165026862124c6f52928cc801"
    sha256 big_sur:        "4435c510ee5baf70f40bb18f32f8677da9318704b2b2daf5082b66bbf998bb54"
    sha256 catalina:       "cda9309784d9f3809b966c8a1c932a2f5e3dc8ea198a3c16075318d72f3ba8e2"
    sha256 x86_64_linux:   "9aaaaa6bd4b2a7198b23262c3938475f2b54390d42abaea4d269a1aa41ae9749"
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
