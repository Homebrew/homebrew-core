class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.38.tar.xz"
  sha256 "a55a98d4772567aa3faed8fb84d540c3db77eaba16d3e2e10b044fbc9228668d"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9c3e051ab78d57cffae42c21f35b82b50132f0cd5aab50f32a7d0210553412a"
    sha256 cellar: :any,                 arm64_ventura:  "52a3e7788102b70454ba01d13a7f4da5575f8e2c489f7f800617cc96f2832289"
    sha256 cellar: :any,                 arm64_monterey: "121ff1300164f39ae6b84545cdb6570126ed4d6d206cd327a54768e827d25ac1"
    sha256 cellar: :any,                 sonoma:         "5155a4e287d38d4946475c404e0a2270ac19af2a264e02fb814a0a9be16af1d8"
    sha256 cellar: :any,                 ventura:        "29b9bf04749277477e2f662e86fd111df994fcc4c7472aeb27c3c8cc2950dc5c"
    sha256 cellar: :any,                 monterey:       "6d49cc922b27489cfa47be23734b3532a944d3559f0e6b4ad03ac41fab856f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afaeb3a4e9482cf3ebd176f75bf9e7527ff9ad9d9773bd07a846b69e96120ed5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dgtk_doc=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orcc --version 2>&1")

    (testpath/"test.c").write <<~EOS
      #include <orc/orc.h>

      int main(int argc, char *argv[]) {
        if (orc_version_string() == NULL) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/orc-0.4", "-L#{lib}", "-lorc-0.4", "-o", "test"
    system "./test"
  end
end
