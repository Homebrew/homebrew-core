class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.3.tar.xz"
  sha256 "5fd896de69fbe24421eb6b0ff8d2f8b4c3cba3f3025ceacd302172f39a8abaa2"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0e0782fb99977a997dc512e68c6753bd5b348462679d6beb0185975a9ad2d822"
    sha256 cellar: :any, arm64_big_sur:  "6a0a76f1c9601665bda8ffbac2fc37eef71acfebf8884a58454ede33cf3020a0"
    sha256 cellar: :any, monterey:       "f6d89657b9c533f08d9ab00273b54957c266e592d857e3eecbf408123b33bd88"
    sha256 cellar: :any, big_sur:        "be1b326db4a4a5da6845c2c32917fd151c26a1dfe61ef2d929233b745aa86e5f"
    sha256 cellar: :any, catalina:       "e9804be1d11e5b1c271a063ef339ce1fb4945bbed123202e4d972c1021437bf8"
    sha256               x86_64_linux:   "d187865c5bcff799a19728bf926924604501e664f486f72705d2daf17398428f"
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
