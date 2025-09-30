class Gtkdatabox < Formula
  desc "Widget for live display of large amounts of changing data"
  homepage "https://sourceforge.net/projects/gtkdatabox/"
  url "https://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox-1/gtkdatabox-1.0.0.tar.gz"
  sha256 "8bee70206494a422ecfec9a88d32d914c50bb7a0c0e8fedc4512f5154aa9d3e3"
  license "LGPL-2.1-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8f8e5772768a8b7e7530d36c8fb991ff76c361cdab7729e508a8e7e8c12dceec"
    sha256 cellar: :any,                 arm64_sequoia:  "5754a6b703bfc85c30adfe1f78b4f5e3416a4d9f04d9531d1c43fb584e136307"
    sha256 cellar: :any,                 arm64_sonoma:   "c4c95de47b74f0a924c88543dfbfc01999cf3491ce8bac5e77b0db2a265bb0e9"
    sha256 cellar: :any,                 arm64_ventura:  "058fb1cf99c7c1a34a9c7b81ebbb8720863009241ad47d69b47efb2f448ff84a"
    sha256 cellar: :any,                 arm64_monterey: "1951c01226523dbbf91a85816a64fed3377b9c4fec4180536b608b93151eafb0"
    sha256 cellar: :any,                 sonoma:         "bfaacbe85617357013ed6368753b261bc87963366680eac5f73cf85183710f96"
    sha256 cellar: :any,                 ventura:        "7a86f4f2915d37de33ae84232fa05588e576a2e0698321501b3a75e0aedd9ace"
    sha256 cellar: :any,                 monterey:       "abc35085101b1fdde0163eb859927e6dcc35e2d38451d033b78206cb24814fa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "60cc0df3c42c25bf990182f6a0e7655292bca03dfcf43821421d0e45a7b02b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1585023f5e6799a8eab163fae37ba597262d3352a01f2bee7763359224f94388"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtkdatabox.h>

      int main(int argc, char *argv[]) {
        gtk_init(&argc, &argv);
        GtkWidget *db = gtk_databox_new();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtkdatabox").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    # Disable this part of test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
