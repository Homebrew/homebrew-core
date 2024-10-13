class Phodav < Formula
  desc "WebDav server implementation using libsoup (RFC 4918)"
  homepage "https://gitlab.gnome.org/GNOME/phodav"
  url "https://download.gnome.org/sources/phodav/3.0/phodav-3.0.tar.xz"
  sha256 "392ec2d06d50300dcff1ef269a2a985304e29bce3520002fca29f2edc1d138d1"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/GNOME/phodav.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "d6beac9ae63de2d6fa449ca75e45a768f2b42fbe01739a6480867a969942f111"
    sha256 arm64_sonoma:   "e71f34ceed2c0b5ac310099aa989f2899c3d6b8a2c135aca3898e112e737437a"
    sha256 arm64_ventura:  "7f62bb9ee32a97be3e81f9fa437e60de55e25ac8b33fcc3a90862616afcbd3cc"
    sha256 arm64_monterey: "84935f58bd6529731b3f854f3afccb7abd495b4545fd753a0414d1352586faad"
    sha256 sonoma:         "19bda4a63bf2f2778e6cb01121f7965c50ac94c839e933e9637a46155315bc32"
    sha256 ventura:        "4645f36c79e05c30cafcefba89de8be68e8af11049ed95c11876f0555200b59a"
    sha256 monterey:       "6b4b21ff80701f00e1b0bad840a6364cdb4b2a69e4d26b1762a0caadd03b3deb"
    sha256 x86_64_linux:   "bf36f39b43b04e8d0dafba15e623f7fb0a7e8873dcd2286a1dc7d62587fa0938"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libphodav/phodav.h>
      #include <glib.h>
      int main() {
        GFile *root_dir = g_file_new_for_path("./phodav-virtual-root");
        GFile *real_dir = g_file_get_child(root_dir, "real");
        PhodavVirtualDir *root = phodav_virtual_dir_new_root();
        phodav_virtual_dir_root_set_real(root, "./phodav-virtual-root");
        PhodavVirtualDir *virtual_dir = phodav_virtual_dir_new_dir(root, "/virtual", NULL);
        phodav_virtual_dir_attach_real_child(virtual_dir, real_dir);
        PhodavServer *phodav = phodav_server_new_for_root_file(G_FILE(root));
        g_assert_nonnull(phodav);
        g_object_unref(virtual_dir);
        g_object_unref(real_dir);
        g_object_unref(root_dir);
        g_object_unref(root);
        SoupServer *server = phodav_server_get_soup_server(phodav);
        g_assert_nonnull(server);
        g_object_unref(phodav);
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --libs --cflags libphodav-3.0").chomp.split
    system ENV.cc, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
