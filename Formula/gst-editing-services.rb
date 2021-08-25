class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.4.tar.xz"
  sha256 "4687b870a7de18aebf50f45ff572ad9e0138020e3479e02a6f056a0c4c7a1d04"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "22be5c42f2f8d13852d3fe7a1d48bff59cbca21b9163a7d9c361d2830acef909"
    sha256 big_sur:       "2f5ec6f0fa4f143367006e9c84a77206b554f362b0010478bd13248d9562cde5"
    sha256 catalina:      "2b3b2e79dd2432db081ac4b8b6561edc587ce08b6abcba9eb74bbc25c7b9d9ae"
    sha256 mojave:        "199d6eb47c8ff8469c7397b97c263b99357d72916437cb41c3d70c3ec8e0f3ab"
    sha256 x86_64_linux:  "fb3afccc5ea7fdc4ecd093913be705b284f647ea65d263a552c4367e3ab2fead"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
    ]

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
