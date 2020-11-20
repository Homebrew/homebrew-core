class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.18.1.tar.xz"
  sha256 "42b289422f7ab32757670848cf2245c5a8a8b08a665a9cab65ded8d69364f6f6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "5d8eb7ef457af5292883e41ef6c2a1cb48341bea1a1282793c35b79d17da4f18" => :big_sur
    sha256 "1963c2fc082acabc26008d6b42c39fa2178b3e2150bffb450aba0ddd76bd7cee" => :catalina
    sha256 "091fddf6465e03df9ada9d0d8a55491d4c8816d5859404ec5ab5fa1815a26edd" => :mojave
    sha256 "274a31d8d6f72e2bb98b2945c839eb58a885c6c783b487bbbe3698d2531b0bac" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.9"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.patch"
    sha256 "734291a1468dff21c61598a36ffa84776d33c113313f5a8c420829ea67f55e78"
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
