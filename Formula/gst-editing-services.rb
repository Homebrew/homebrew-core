class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.0.tar.xz"
  sha256 "f837adcf4073d19a5908984e879cd039f4192ca368e71d39e8ccd8a56b9feedf"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "bc9faf8f9ee1c006d98a5209e8b1a1b53ce41facff7f79a3463cf6674be0c0ff"
    sha256 cellar: :any, arm64_big_sur:  "20543ff1dd9615a33cc1c3ed0f4a2048ebdbcca2c6b088fa1e3e5294a086030f"
    sha256 cellar: :any, monterey:       "fb747140eabca711d8d06a3f0d3e9b980c69691921d8a24b58deb20612ef1105"
    sha256 cellar: :any, big_sur:        "2d49eef7d705b830d02398ead8d24140dcd618ad61b57e3026c28d7a129bd50c"
    sha256 cellar: :any, catalina:       "124a991e88f1fdc6be5432529382302301ff283b59fd3eaab1d2586043645a1b"
    sha256               x86_64_linux:   "6c53aca54d7ed4e3bb37a8f15cf9caca3d114d8e858777278aeae263f333f595"
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
