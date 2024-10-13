class Libgdata < Formula
  desc "GLib-based library for accessing online service APIs"
  homepage "https://wiki.gnome.org/Projects/libgdata"
  url "https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.1.tar.xz"
  sha256 "dd8592eeb6512ad0a8cf5c8be8c72e76f74bfe6b23e4dd93f0756ee0716804c7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia:  "36b90319012266b453dbafde5737f7a9a0d0570494af7fd9f71c9ac836445d51"
    sha256 cellar: :any, arm64_sonoma:   "11ea8fc6cbcecdbf469a94c4d0f11fef09947c51781ca98a103648983be3c643"
    sha256 cellar: :any, arm64_ventura:  "5e030516ecc07a1b31b7db82b7eeda2d828f8a742f5daf9c1aced0dc33b4fb4f"
    sha256 cellar: :any, arm64_monterey: "b262fab7a6607c82f01cb2c46098e6acc0cd0f8ee50f34d56789df69f5f03bc7"
    sha256 cellar: :any, arm64_big_sur:  "b5285aafaa3e8096eee5ffebd4c144e01b0a61d9e7d510dbdfbbd7acde33a3d8"
    sha256 cellar: :any, sonoma:         "32782ca2e84f3aa0d132613e8d3319ee00fe7a7275c957401e930d13256bbbdb"
    sha256 cellar: :any, ventura:        "c99a9af5d3dc41104d3f334fae4b64a74f20bc76fc20120c0ae484f761209ef8"
    sha256 cellar: :any, monterey:       "51f3dd89ac7e6c40a35c0c629ea385a558942d00eff37864925c038b0d185eab"
    sha256 cellar: :any, big_sur:        "02e1ac992638692a58f8bb8313168c8e62117e6bab46ba447fc52b16b3f0127e"
    sha256 cellar: :any, catalina:       "45066a1abdda5d00f7a6a41f6e1b1a3bc40e9faa2de3701372ac237ce776eb8a"
    sha256               x86_64_linux:   "47559f0a3203d2274cf17141c8a8812b166d41b1a0522b00053d64e70c514085"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "liboauth"
  depends_on "libsoup@2" # libsoup 3 PR: https://gitlab.gnome.org/GNOME/libgdata/-/merge_requests/49

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    curl_lib = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr/lib" : Formula["curl"].opt_lib
    ENV.append "LDFLAGS", "-L#{curl_lib} -lcurl"

    args = %w[
      -Dintrospection=true
      -Doauth1=enabled
      -Dalways_build_tests=false
      -Dvapi=true
      -Dgtk=enabled
      -Dgoa=disabled
      -Dgnome=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdata/gdata.h>

      int main(int argc, char *argv[]) {
        GType type = gdata_comment_get_type();
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs libgdata").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
