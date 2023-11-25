class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "3b1a393f36a1b0ddc29a3d5111d8707f25fb2dd2d93b0401ff1c66fa95f50294"
  license "GPL-3.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "4b76c88f065350a748304511382c62d9418dbbcea2baaeddbd749a1a7e27322e"
    sha256 arm64_ventura:  "1aace7c3c440270bc84311fe981b884ad25ef95124ff8bb20ad8e1987a0b48b6"
    sha256 arm64_monterey: "845616bcf0c462c48d7fe8560a990049cce37122a64f146048b2315b0a1c39eb"
    sha256 arm64_big_sur:  "1460cd4ac02aabc384a1ef9f63b80d39324f20599071b1b30bc658d38b79b97e"
    sha256 sonoma:         "5ee19f8d32c1e6ac995d93e54cdc68a192ce63c0cee67c33f9bb6b104ff497cb"
    sha256 ventura:        "0db9b677c52f7918f1e880e732ab22dab9c497930540358cf8b5bbd1bbe4adaf"
    sha256 monterey:       "394fdad94e1359040ab98677190efe4088eb7ce722a12a256ac05a76447b14e3"
    sha256 big_sur:        "e9326d3ea690dc41682ff022c73798e14113b502779e295f737c62b2ccf74233"
    sha256 x86_64_linux:   "aa2f690eacb00966ce31538971a580c18fabbefd1c222ddc69918c83a396e561"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "discount"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "libsoup"
  depends_on "poppler"
  depends_on "qrencode"

  on_linux do
    depends_on "webkitgtk"
  end

  patch :DATA

  def install
    # Build with `-DREST=OFF` as it requires libsoup@2
    # https://github.com/pdfpc/pdfpc/blob/3310efbf87b5457cbff49076447fcf5f822c2269/src/CMakeLists.txt#L38-L40
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON",
                    "-DREST=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"pdfpc", "--version"
  end
end

__END__
diff --git a/src/classes/drawings/drawing_commands.vala b/src/classes/drawings/drawing_commands.vala
index 77e56e6..66a906a 100644
--- a/src/classes/drawings/drawing_commands.vala
+++ b/src/classes/drawings/drawing_commands.vala
@@ -54,8 +54,8 @@ namespace pdfpc {
         }

         public void clear() {
-            this.drawing_commands = new List<DrawingCommand>();
-            this.redo_commands = new List<DrawingCommand>();
+            this.drawing_commands = new List<DrawingCommand?>();
+            this.redo_commands = new List<DrawingCommand?>();
         }

         public void add_line(bool is_eraser,
@@ -70,7 +70,7 @@ namespace pdfpc {

             // After adding a new line you can no longer redo the old
             // path.
-            this.redo_commands = new List<DrawingCommand>(); // clear
+            this.redo_commands = new List<DrawingCommand?>(); // clear

             bool new_path = true;
             double epsilon = 1e-4; // Less than 0.1 pixel for a 1000x1000 img
@@ -171,4 +171,3 @@ namespace pdfpc {
         }
     }
 }
-
