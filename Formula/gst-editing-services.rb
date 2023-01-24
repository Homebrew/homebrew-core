class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.22.0.tar.xz"
  sha256 "2a23856379af03586b66c193910fa8bb963024580bc2337c7405578dc077aa79"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "350847754b709bf4a12382c0b739d4f6c7a915a06c04280ffc6217c2f7f316ab"
    sha256 cellar: :any, arm64_monterey: "b897169bf8e6ab9e216f428728961d7b0416f14a0ab0861ab8e9af2963c76088"
    sha256 cellar: :any, arm64_big_sur:  "13296adb58f07bfaedfc2e315b9d3f8b5b402dab309e9af0f43eeabdd940bf0b"
    sha256 cellar: :any, ventura:        "df261d0fda23abe20709ba76ac1695cd0b5baf13f9fa16872f5ffc520fb00e7a"
    sha256 cellar: :any, monterey:       "1461af3a7870ce419d2a9c00b26fcbee2990493232b5c8d86388a98361d9e310"
    sha256 cellar: :any, big_sur:        "98ff0425eb459b8086cc85dcca35cb93f684c5fd8309886c7af7a36bd1496e98"
    sha256               x86_64_linux:   "4cfb586e63168a90365a5b5a4544f1fb5439af135e9f371ecdbbb0e22c9b991a"
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
