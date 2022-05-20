class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.20.2.tar.xz"
  sha256 "853ea35a1088c762fb703e5aea9c30031a19222b59786b6599956e154620fa2f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dc1aa9d0bfef11f2d5b019fb99c92618c4bba7a4ccd25e7b6cfe491f60ec9061"
    sha256 arm64_big_sur:  "2c786cbbd3bbe037d9072839d57eaed356e5b5577976793edd9886f1ce4a796e"
    sha256 monterey:       "02378c59899cce7605abf9ab809620d4d2c55e5e1cf81f0fa73394989953254f"
    sha256 big_sur:        "27b74898e1cb61e1c5d89151993fce2a87606a7a580686bcc0b11aa5ad96aa2b"
    sha256 catalina:       "3ffc38ddada57f28afe8a7caf1041696cb8d7137f6344830b10a885dffc0c2dd"
    sha256 x86_64_linux:   "cf9d22c7f95758cf31168922aae59fd1d4ca6fd55867caadb97c52b17643545b"
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
