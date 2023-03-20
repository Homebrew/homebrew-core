class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.22.0.tar.xz"
  sha256 "78d21b5469ac93edafc6d8ceb63bc82f6cbbee94d2f866cca6b9252157ee0a09"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5468805db7fd0701f1f99d3977af05715fe3ccfa4b2e12981257a29dd1cd9b74"
    sha256 arm64_monterey: "7e18a5e269a85196399d131d5ead2fc07475cad5c95c831072aebdda739a6bee"
    sha256 arm64_big_sur:  "8e3d187cf2498e9709432323a63ed2aa8f58cc572150808cf67293ecbbecd679"
    sha256 ventura:        "b93ab7a921ad578e404bcc1adca95fb2664ac0dc97a76a1e843bbc9cc83b1336"
    sha256 monterey:       "57144fd13b89c0c128944f2ce844428d386216455f09585f2739757a4fc44016"
    sha256 big_sur:        "856d0a949a6116e5faf472e4f365d413f370bb583944ee9ff0c6fa888ce26bf1"
    sha256 x86_64_linux:   "cf16cedfa1fbf8c2176bec39158bfed3a0c58ee4b92e7c88cd9ca50a422aaf5e"
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
