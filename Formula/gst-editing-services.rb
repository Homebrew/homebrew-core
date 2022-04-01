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
    sha256 cellar: :any, arm64_monterey: "b448555dee94ed82d381add836f9189db00301c1e4c7a315f7e3a606fe4fc839"
    sha256 cellar: :any, arm64_big_sur:  "398e7585a34c6741e333ad26b16c922bd887fda14dfb30138f1ab572ee36e746"
    sha256 cellar: :any, monterey:       "83f505bf5dba5e182d41fddc567c8d8b77d19c261a848d648835b964ea80f787"
    sha256 cellar: :any, big_sur:        "3091b92c556da6b5757ff7aea4cee2facc01ea42700b6fb53d3a81d525c86b0b"
    sha256 cellar: :any, catalina:       "6216cae04e11a6d04b796db2a78447fa1613e66f9a04615b027177627b99575d"
    sha256               x86_64_linux:   "58b0cb8eb13a043ecb7b1b90360129a54b9424c2910fc515d563298d0bb8145c"
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
