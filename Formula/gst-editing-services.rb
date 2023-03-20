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
    sha256 cellar: :any, arm64_ventura:  "bb860fbacd097da3a94b520906af0272b4fc8346d08f477d82135a7c4d2b8708"
    sha256 cellar: :any, arm64_monterey: "ff5a325d28ee8a49d593ae84ef46042fdc866785591a95dab484a467189b807a"
    sha256 cellar: :any, arm64_big_sur:  "c55d011a7f984073f8f27ff22bc6ebc9a03bd914458c98bb08a8fddd08833f63"
    sha256 cellar: :any, ventura:        "1c8309c94b7c179b40b02e55a2b5a1d659b704fcd217485d27799b47458a1464"
    sha256 cellar: :any, monterey:       "94c21e0c4d1656efe224e505459456f788816e9534653f44f1400f670821715c"
    sha256 cellar: :any, big_sur:        "31537cbec5e63bc5a677e3d2c2f53271476e047d67772946154d0986e789da78"
    sha256               x86_64_linux:   "b5cb7c011c8d442490c83ea74def78496761b0cda60296f2788d5c11f13303c0"
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
