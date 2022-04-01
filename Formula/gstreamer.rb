class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.20.1.tar.xz"
  sha256 "de094a404a3ad8f4977829ea87edf695a4da0b5c8f613ebe54ab414bac89f031"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dd425d8ae882c6d2119e51ebc6ef10742472fa7b6e3e250e728ae893f555ae38"
    sha256 arm64_big_sur:  "1715bbe4b0b2c4880a8e557eb8670a9f82203b7acbe84dcf1e2e9362000bb28b"
    sha256 monterey:       "899a70db3e2c7192a5908a8b7ab1de0d22d4973ab35951901a867d89be4f0e11"
    sha256 big_sur:        "36d32c9bc0c06b18b5e393594c3e017ef8a92bfe7373bfc8eb344be3364f7cd2"
    sha256 catalina:       "52b662142cc56997c1a809ddc5aaeb39fec140b0cbe3cd36fa22faeca86fad67"
    sha256 x86_64_linux:   "1b564a43905edbe270da0ea2b0c9ed565a144b5d78e7e6b6221a7e287a4ca5c1"
  end

  depends_on "bison" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "flex" => :build

  def install
    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dptp-helper-permissions=none
    ]

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "meson.build",
      "cdata.set_quoted('PLUGINDIR', join_paths(get_option('prefix'), get_option('libdir'), 'gstreamer-1.0'))",
      "cdata.set_quoted('PLUGINDIR', '#{HOMEBREW_PREFIX}/lib/gstreamer-1.0')"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    bin.env_script_all_files libexec/"bin", GST_PLUGIN_SYSTEM_PATH: HOMEBREW_PREFIX/"lib/gstreamer-1.0"
  end

  def caveats
    <<~EOS
      Consider also installing gst-plugins-base and gst-plugins-good.

      The gst-plugins-* packages contain gstreamer-video-1.0, gstreamer-audio-1.0,
      and other components needed by most gstreamer applications.
    EOS
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
