class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.1.tar.xz"
  sha256 "e93cb3f1896565c57defa72758e49b6eb6685e0f804abd184f395c94822a3927"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "69e56dd1d543243bcf4213be33da4610d377a630f58f85ce3495920f9fbe774f" => :big_sur
    sha256 "c852fabdc2ea836956cb54efce308f5739e4908c5e4f479f89008a16d30333d6" => :catalina
    sha256 "5eb26d65a3b9b2ab8ea0d1cfb08a059b53a08531bee31857707a59f28d5b7322" => :mojave
    sha256 "688eab7b97190c31e1cb6cb8673285526237bbc1a0d88913d89547a95fadccf3" => :high_sierra
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
