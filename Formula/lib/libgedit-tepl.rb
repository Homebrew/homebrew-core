class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.10.0/libgedit-tepl-6.10.0.tar.bz2"
  sha256 "bfaf68a4c81b7e32ff69d102dad1d656c49b5ef8570db15327a3c5479c8c3164"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  # https://gitlab.gnome.org/swilmet/tepl/-/blob/main/docs/more-information.md
  # Tepl follows the even/odd minor version scheme. Odd minor versions are
  # development snapshots; even minor versions are stable.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d0ba4da39b07185f98be03d9d664ce1db2aa99698dd545fe7d41cca8c509ab9a"
    sha256 arm64_sonoma:  "69dfe861bd519068043df4d769a91884181eac275b22fc603a8e8703e47f3605"
    sha256 arm64_ventura: "e0cd8a12348aeb9222a3d9cc98b6a78b77ca623cc03b5f2846a514db9181e31b"
    sha256 sonoma:        "ea9146aeb23f78c5550b8a41a1eaaa9dfcaa6a54f0f5cc476f2711b478f1fa61"
    sha256 ventura:       "f653793e0d6ba2dcb539557a476b7c79922f0b44b8a8c187f2aa784f7579ffe3"
    sha256 x86_64_linux:  "1ea4508523ffb2c00b8b9fe1fd91f6fa61d7373266880fb680533a15052c6067"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@75"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libhandy"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # `pkg-config --libs libgedit-tepl-6` includes icu-uc and icu-i18n but modules
    # are from keg-only `icu4c@75` so pkg-config needs to look in the opt path.
    # TODO: Remove after https://github.com/Homebrew/brew/pull/18229
    icu4c_pc_dir = Formula["icu4c@75"].opt_lib/"pkgconfig"
    inreplace lib/"pkgconfig/libgedit-tepl-6.pc",
              /^(Requires\.private:.*) icu-uc, icu-i18n,/,
              "\\1 #{icu4c_pc_dir}/icu-uc.pc, #{icu4c_pc_dir}/icu-i18n.pc,"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
