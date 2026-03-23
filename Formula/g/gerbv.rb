class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "b9a01ed892702f21f78b6ef4ec701e2db3220b5702d1cf93b10e843cad1e69a1"
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

  # Backport CMake fixes, upstream pr ref, https://github.com/gerbv/gerbv/pull/303
  patch do
    url "https://github.com/chenrui333/gerbv/commit/13e73c2767f0170cd4ff660ba0ccceac7c080573.patch?full_index=1"
    sha256 "d1e8adc4371cfa3b2cc033b06c26daf2aa219cdd8d7a58b3fadfbdc0cbf9f920"
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
