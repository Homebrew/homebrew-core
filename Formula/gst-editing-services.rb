class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.5.tar.xz"
  sha256 "8af4a8394d051f3e18280686db49a6efaccc95c0c59a17f0f564e32000590df5"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "89f4c13a710b763ed18d037bb3e40925d1ce1ea45cce618dc5ccbe81335275d9"
    sha256 cellar: :any, arm64_big_sur:  "35a025c34cb830cdabd8d203e234635147cfaf6e3591db0c87075ee8e7e7a02c"
    sha256 cellar: :any, monterey:       "9ba2e409fdd5be6572dea8d9da243d47df89323c94231525353b78611345c3d6"
    sha256 cellar: :any, big_sur:        "5b7ed1e735926c4d0fefc0247afb49067430f5f0b5d100ea46c44e07a8c8944d"
    sha256 cellar: :any, catalina:       "959c755c7ab4aa89fc83c94ebbc56c5fce492b12b58586e9f9e2ad5f942e121b"
    sha256               x86_64_linux:   "e0ed4f116e48cce4c326c3aef3450b1f8fd30bdfcdc9bbbe9926806c4ffcd783"
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
