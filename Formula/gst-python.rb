class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.3.tar.xz"
  sha256 "db348120eae955b8cc4de3560a7ea06e36d6e1ddbaa99a7ad96b59846601cfdc"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "515b686b5530cf30f7e4c83097b9564356a629552522eec0bad876a5ddda33db"
    sha256 arm64_monterey: "c7bd54bf59d884fece2bd93a8aa87156b1711fb792769e2e824b7980fe804fbd"
    sha256 arm64_big_sur:  "46577a49c80650c862830b1dfc739962dcf3181b03ec2af19f6e03adb3731d31"
    sha256 ventura:        "5c46dd4bb09b1da3ed57f74d49b32932b40dce10031f1929050008957a447a81"
    sha256 monterey:       "7726dbe8e9697fc1704c7ed442fcfdcb7f5308b0b7ca573fee7d697b42978e8c"
    sha256 big_sur:        "a12e52607ac75e19ee6712dddd5d6d27f403dd5feb4d4fa942ce432c566f2ce3"
    sha256 catalina:       "6677dc74dee5380d456c0615390eeaefa55cdc3ec7e892c66cbb95a8c78e863c"
    sha256 x86_64_linux:   "a3ed0216139c282fa4c8304a40c52da5e97d7a2403c9cd135fb3801d17ff82a1"
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
