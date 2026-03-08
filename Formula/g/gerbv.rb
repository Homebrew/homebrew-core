class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "4c7c571233f4f7b9e1a0cb81df037053420dd723ba6791cc0ad45eb65b4dbb3a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4dc6433925aeac44a2a626ba71738c2e34758a19f4f50cad7a194e61f8052fa4"
    sha256 arm64_sequoia: "359c1d89dffeabd88988af8a7c8d76d0decc38b25b34adeabd9b98d1e7b0dd71"
    sha256 arm64_sonoma:  "721a75cbe5f39991039fe5a30fe70897f9054da0690f7bf9013b3d88642e7900"
    sha256 sonoma:        "7520ca2ae7c43b1c466c3d150403cffd43815ad79c0ccfcca1d611ba8cbffdef"
    sha256 arm64_linux:   "31c9be5a7194ec14a38eb81f4eb60ac0d8e7cef0bca37852a286d0a3c261790f"
    sha256 x86_64_linux:  "1552e7fc822f0fb03a3768d7aa095d70c7b1bd9ebee8dfa4d6efa79b8e2155a7"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    # Ensure generated gettext sources exist before parallel translation build.
    system "cmake", "--build", "build", "--target", "generated"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # executable (GUI) test
    system bin/"gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgerbv").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end
