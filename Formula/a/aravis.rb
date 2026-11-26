class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://github.com/AravisProject/aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.37/aravis-0.8.37.tar.xz"
  sha256 "231d22a63d3f8bcd0aa7868c05210b6ab532ea73a04c969fa8c9c643eff9a60c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "378b127348b0dda26a835ad15e589419a112d26fd85d6e7580ad0c79e58f4e81"
    sha256 arm64_golden_gate: "32d05ebf43e0a79d09f121c0a7ade9e99e237c363fac70ef3e9b1d04492784b6"
    sha256 arm64_tahoe:       "e754299ca0333c6eabfcf76fa59d666c6473ce345b8635818b8c78b499738e2d"
    sha256 arm64_sequoia:     "4d3a32a6bb474dee4948c3df3a5afe4ac59d74131c7a756e9d578d809fc15baf"
    sha256 arm64_linux:       "5d11b6bb82d86826ee0a969576eba63d2b9826357b13f3333958fa8611ec2bec"
    sha256 x86_64_linux:      "e1c5f1bbddb434a97ad90603daccca211c4f6ae0c41d862774da74033819ea45"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

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

  deny_network_access!

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
    (testpath/"test.c").write <<~'C'
      #include <arv.h>
      #include <stdlib.h>
      #include <stdio.h>

      int main(void) {
        ArvCamera *camera;
        ArvBuffer *buffer;
        GError *error = NULL;
        camera = arv_camera_new (NULL, &error);
        if (ARV_IS_CAMERA (camera)) {
          printf ("Found camera '%s'\n", arv_camera_get_model_name (camera, NULL));
          g_clear_object (&camera);
        }
        if (error != NULL) {
          printf ("No camera found: %s\n", error->message);
        }
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs aravis-#{version.major_minor}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
