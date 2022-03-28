class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.1.tar.xz"
  sha256 "6ace1b21b58e0110b7dadd469f79b77e2f47d6207604231492531ae9fd4148df"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "16c1823ab169aeae9f9bc91c504ff0ac7674e6b66e869b5e0471534ff9174a39"
    sha256 cellar: :any, arm64_big_sur:  "f84ad9a567956a39ef83b332ad0891037b29f205a689ac9516865ec99e66266d"
    sha256 cellar: :any, monterey:       "896ecf11ab448f7383cddb65c6861e51c9e6d232072cbe492da113020650d181"
    sha256 cellar: :any, big_sur:        "5a30a2d90b4de3970bd307a159a1572579e21eb8846c16890114db4b4dc29714"
    sha256 cellar: :any, catalina:       "9e8c173b5dca69a4bba668d3dc898a27fe221b06e87b71a2acb564e793d1e900"
    sha256               x86_64_linux:   "333ad0a639f2e421fdac66eb22fa5c78cc2ab4896b380904c9734ab5374fcb90"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "json-glib"
  end

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
      -Dvalidate=disabled
    ]
    # https://gitlab.freedesktop.org/gstreamer/gst-editing-services/-/issues/114
    # https://github.com/Homebrew/homebrew-core/pull/84906
    args << "-Dpython=disabled"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
