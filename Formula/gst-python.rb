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
    sha256 "efdf868f18e030733a6566e3cf50badf8db40b52004ba8c8f6d3696f35642ecb" => :catalina
    sha256 "9f25b45ffd7d92f63043fe1d91da0de3e5c6944ab286e2a496f7979b70c0acd5" => :mojave
    sha256 "a82ac49ea697ccb26ca6e58541fc171fc6aa18d7caba13d0f2422810fc5e866a" => :high_sierra
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
