class AyatanaIdo < Formula
  desc "Ayatana Indicator Display Objects"
  homepage "https://github.com/AyatanaIndicators/ayatana-ido"
  url "https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/0.10.4.tar.gz"
  sha256 "bd59abd5f1314e411d0d55ce3643e91cef633271f58126be529de5fb71c5ab38"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "fdd3dea9088ce3de66656684a292ac3cabe7540fe8e58df4d42421d356c2bfc5"
    sha256 cellar: :any, arm64_sequoia: "768bbbd7532ca49a378cd7e79700b73257ae55344f0cc7c2f81817cd899e14be"
    sha256 cellar: :any, arm64_sonoma:  "0a6a4182d499d52448b951844b5aeae9766b4306c874825bce33c79bb69e9a5b"
    sha256 cellar: :any, sonoma:        "bcfe9b250aded01df24c30e98a9af7f59dd4977de6943dbdbfbd05790d8039ea"
    sha256 cellar: :any, arm64_linux:   "f0b910095890cd349897387533b4f43b45c185a3d7f904c29711d35869a67e6a"
    sha256 cellar: :any, x86_64_linux:  "8f0d6f6881280961dad410b8a81dbc5ef48b7ef76c3e34fbe8c7c3cf63531e40"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-ido/libayatana-ido.h>
      int main() {
        ido_init();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libayatana-ido3-0.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
