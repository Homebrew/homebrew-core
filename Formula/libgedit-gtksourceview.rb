class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.net"
  url "https://gedit-technology.net/tarballs/libgedit-gtksourceview/libgedit-gtksourceview-299.0.2.tar.xz"
  sha256 "467fde5fec7fab80638bc10d75739565bf88b9c6f82544b6a6432f1f694a9811"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "b70eeb24da35f08ef2155efc7ca5b26e3c9a17c9e268f21d1b9bcba75693a001"
    sha256 arm64_monterey: "082187ddc156805492b0995e18912932d6414556f9a809d842a2ece0837fb199"
    sha256 arm64_big_sur:  "2fe3e642fea66b7c6244210818179e18c06ae7787bea12cd14076ec78581d693"
    sha256 ventura:        "058e2e1a7a6c595243a6b22c1ee0ba5072b88be4dae99d154537666502ad0c9b"
    sha256 monterey:       "9f51aca690cccc65fce7c123d7d146d2ddc0b124e763b77232f4990c9ff9f5be"
    sha256 big_sur:        "6c4073bb651e3a9a7a71bcb5fb199568e432a4104d30b2709816afd3ab208afe"
    sha256 x86_64_linux:   "c66565b0f9162c83b4fa7d7e8c2232ec4863e87ed00d758d633b3a55267c2fc0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-introspection"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
