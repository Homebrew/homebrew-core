class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.3.tar.xz"
  sha256 "db348120eae955b8cc4de3560a7ea06e36d6e1ddbaa99a7ad96b59846601cfdc"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d2ec9fdb1aacd15f3e15e74c4fe3874dc4026fca340343e7b33ce36cc547d74d"
    sha256 arm64_big_sur:  "a80064fa901949301635f6fed07cab928163ab540db94d1ad337b153d19bf8d8"
    sha256 monterey:       "6f50fe5339425c4bef2fa24301ab9232c76fe1620aaabecbfecd4be322f9f3c6"
    sha256 big_sur:        "9a91dae7c2006db63427324837713bf4a629541dcb0d66d6d4535bd926f1e196"
    sha256 catalina:       "e88ade86caf15f19ccf0ac48649e64433f7d5e9fc6a7577c2712b4f66b2a79f4"
    sha256 x86_64_linux:   "7f6e66d3e2e2e5922cbd99aedfe3f5d0f4b6134ce5daaf757e2bc3909de33548"
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
