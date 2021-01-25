class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.3.tar.xz"
  sha256 "8ae139b13b1646a20ba63b0b90877d35813e24cd87642d325e751fc7cb175e20"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "ed53b867be2572ec44bc8fd01995ed827203b78d4fb18864d7ae8248106a790c" => :big_sur
    sha256 "b0174087dfb2d530285b40273cbbb6cb74d2ea2a42d3bc8a7cbda4f71b902d50" => :arm64_big_sur
    sha256 "5d86ceb3e5cc751f88b06cc2e784adb700999721cae2056f3ec3d08abca33783" => :catalina
    sha256 "550f8a907c10cf7318bb5f4dbd486d3a34a1838bb0d7b5e2bc02f03025432b89" => :mojave
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
