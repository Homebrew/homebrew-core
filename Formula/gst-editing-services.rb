class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.5.tar.xz"
  sha256 "363f2b13675877b926b4be5259dbbeea8cc976805b40c871fc254bb8f382017d"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0baf85c9c2e702e8feb54ae87dac4731fce18ec72abbcb7e4d8e5bb5e446694f"
    sha256 cellar: :any, arm64_monterey: "7d0337d1d7c99b869d237613c72f027b922f957737433c492768ad03f36efb12"
    sha256 cellar: :any, arm64_big_sur:  "8347c9b21bf80484c28f667593218bab4ba242220c0bab427c0d8ad58e5f2f6b"
    sha256 cellar: :any, ventura:        "6a875d505a15166fd20137a02f048b0c055c703839641fa8b7b7636e6e37b06e"
    sha256 cellar: :any, monterey:       "346c219ce1034f518a514a2b1be52502c3f59e77b4910ee279b5ca4634179f50"
    sha256 cellar: :any, big_sur:        "d9b9128abf509322f50f5c6e049cbfd8a0f79e33892312ca92d49b87aeac4d81"
    sha256               x86_64_linux:   "a35dd006f16b2a33efcf37ef934a976eb8937e7f38f0b8be28ae14baaf1d0a62"
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
