class Gdl < Formula
  desc "GNOME Docking Library provides docking features for GTK+ 3"
  homepage "https://gitlab.gnome.org/GNOME/gdl"
  url "https://download.gnome.org/sources/gdl/3.40/gdl-3.40.0.tar.xz"
  sha256 "3641d4fd669d1e1818aeff3cf9ffb7887fc5c367850b78c28c775eba4ab6a555"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_sequoia:  "2e9f8f552db78335d815e67a085b8d26e42002308d0b138ec1dbdf9aba2b232f"
    sha256                               arm64_sonoma:   "1cfd6543098b8fbd77e7fd87c1c16f37d6f486c50323e39bf2d52605409b0f11"
    sha256                               arm64_ventura:  "d896433e025e9c24f986d70fbd82afca5692a82a1a94613b6f4542f341a9896d"
    sha256                               arm64_monterey: "b3769eef48ccbaf262852d48819309afac933d962c7464d4fa3e28a1449b0334"
    sha256                               sonoma:         "4696c6de941ce9c03db4631ce5bc3a53d83f5edfdbff117b3d9c4cba1af3ca1f"
    sha256                               ventura:        "9485abd2cefbb7793c73f8de136bed12524f5e54452bc89b386bc19274f09b1b"
    sha256                               monterey:       "96f6f072cd160b556e5f3e02eb8ffd5cbbe1d4a77877d8f1f4b0d9d986bdfc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b01e8322122e6bbca3d696cb820b83409a1320a3439ef5aa3f56a2de3e908f"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libxml2"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # Fix build with libxml2 2.12. Remove if upstream PR is merged and in release.
  # PR ref: https://gitlab.gnome.org/GNOME/gdl/-/merge_requests/4
  patch do
    url "https://gitlab.gnome.org/GNOME/gdl/-/commit/414f83eb4ad9e5576ee3d089594bf1301ff24091.diff"
    sha256 "715c804e6d03304bc077b99f667bbeb062c873b3bbd737182fb2cd47a295de95"
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-silent-rules",
                          "--enable-introspection=yes",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdl/gdl.h>

      int main(int argc, char *argv[]) {
        GType type = gdl_dock_object_get_type();
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gdl-3.0").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
