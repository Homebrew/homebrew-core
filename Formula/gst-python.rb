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
    sha256 arm64_ventura:  "0aa72dc7195f547c39798a1c67b60ef93859364fd1cc0ca26e2c5b09de48895f"
    sha256 arm64_monterey: "bc688b37f9e322aad1220e1b8224878134631fb26fe7ebe8d85e68e8ceedefbf"
    sha256 arm64_big_sur:  "ff1862926c906426bb95dd517360b3b232b94ea06551b405df005d536771002a"
    sha256 ventura:        "6df34c0c80ec7387d77b3a2c54c23b1baa2d9ec521a4b57237af3a61fba57801"
    sha256 monterey:       "50ca198accf4076231df60b0fbb014b272b79c1541078303f7bf4e031878444d"
    sha256 big_sur:        "e09a7c9030649452515dad14a484015599c2995532bbb9aceed7791c85c1537c"
    sha256 x86_64_linux:   "89ac1bffbc7d622e935d39f905c160c9a520e1619b40e21e91e07b666cfdd524"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.10"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.diff"
    sha256 "d6522bb29f1894d3d426ee6c262a18669b0759bd084a6d2a2ea1ba0612a80068"
  end

  def python3
    which("python3.10")
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
