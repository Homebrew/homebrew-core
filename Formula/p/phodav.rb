class Phodav < Formula
  desc "WebDav server implementation using libsoup (RFC 4918)"
  homepage "https://gitlab.gnome.org/GNOME/phodav"
  url "https://download.gnome.org/sources/phodav/3.2/phodav-3.2.tar.xz"
  sha256 "93c993066ab3aebd5b539bab9d731eac43abbb750109c895f151ca3c74a5fc82"
  license "LGPL-2.1-only"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/phodav.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "7642ef26f83be662c5e1cca389e7c9308118387b205b9a33833c28aa021c4ae5"
    sha256               arm64_tahoe:       "e51a4b28d1e6f6692ce908c9ae87972c72169cdc566cbf08f447795d68c1480a"
    sha256               arm64_sequoia:     "6f2de9474c1f0e6630e5432d8295e7ff3c39bc1d22ea997e0f28343367d017ce"
    sha256 cellar: :any, arm64_linux:       "af245a6b743c79933b79e458d1f9baae51b46b9dc665f887ca5a6bda180503ba"
    sha256 cellar: :any, x86_64_linux:      "4c93cf5ad70a0c6927f4f23a0ffdfbc703722b91909a89e8534045a14956da86"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # `tests/spice-webdavd.c` sets `_XOPEN_SOURCE`, which hides `cfmakeraw` on macOS
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkgconf --libs --cflags libphodav-3.0").chomp.split
    system ENV.cc, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
