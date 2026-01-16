class Phodav < Formula
  desc "WebDav server implementation using libsoup (RFC 4918)"
  homepage "https://gitlab.gnome.org/GNOME/phodav"
  url "https://download.gnome.org/sources/phodav/3.0/phodav-3.0.tar.xz"
  sha256 "392ec2d06d50300dcff1ef269a2a985304e29bce3520002fca29f2edc1d138d1"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/GNOME/phodav.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "f1192115b21287b4a91568fa9257b8db536bb3529471c9fcf09da51f43408206"
    sha256 arm64_sequoia: "275e604708cdfcd2d5468532bd3ae37c7fc914f913ae2923b5c10b05d9ccab89"
    sha256 arm64_sonoma:  "2164243dc4377c2624727447888926105498bb67bce02636811d5488bf9438dd"
    sha256 sonoma:        "1b958681dab50441f112f3cc754f79f2f7f3a7766af6b5a85318a64d3692b5ad"
    sha256 arm64_linux:   "5d8943c4e2ebdf97363b6d5efc2d000debf452fd8d6614efba08e6ce05a2501c"
    sha256 x86_64_linux:  "44add3c66eabacd501c955a9ec7e41dc7c966b6abbf74df01d533bf1c25f2e69"
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
