class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.36/aravis-0.8.36.tar.xz"
  sha256 "246deaa0042a387ff1bc00332d0fb80537ce14abde2c28d1a54c91f17adc51bf"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "e8d380d1205bfed309d38e061c3b16e3f37158a6b479655e7aa35554f65fb9da"
    sha256 arm64_sequoia: "400d547af062c952574b486a527d3786426c2eb3b47565127c403ff34398835f"
    sha256 arm64_sonoma:  "e78f7ca072dc2131c0907a606ff7ada754ebffddb3f6d4ea6ea5598857eb034d"
    sha256 sonoma:        "2a070b911bdbc1533cfb68d00720a42244e64db5c2b41020766265b3077a55ca"
    sha256 arm64_linux:   "567ebd2a64d8f9e4510cde9d566d90a3fbe5d2838763f8ae20c2acae4932291e"
    sha256 x86_64_linux:  "75d4c78de8f32363d240b1d556b2da2c137173cf1ce02f9b99ead801dd352f7d"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libusb"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    update_gtk_icon_cache
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}/gstreamer-1.0
    EOS
  end

  test do
    # The initial plugin load takes a long time without extra permissions on
    # macOS, which frequently causes the slower Intel macOS runners to time out.
    #
    # Ref: https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/1119
    ENV["GST_PLUGIN_SYSTEM_PATH"] = testpath if OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
