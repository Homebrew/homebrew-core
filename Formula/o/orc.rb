class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.41.tar.xz"
  sha256 "cb1bfd4f655289cd39bc04642d597be9de5427623f0861c1fc19c08d98467fa2"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89375069efcb10db89dc7379679b12f8d0be120b8bd31921ffa66b9df4ae8926"
    sha256 cellar: :any,                 arm64_sequoia: "8ec6640411fd5de65f5064ac884686380efb68725317a0121e3ecadbdcca196b"
    sha256 cellar: :any,                 arm64_sonoma:  "3dae83cc3cd5a637b63a012b72f45dafccd4b45da20c86dbc2eea6e7827d166c"
    sha256 cellar: :any,                 arm64_ventura: "fede6fc3e9d0b04237bff31412097f951b2744a28270dacb0746a8fe61b27952"
    sha256 cellar: :any,                 sonoma:        "825f58d2fd7605ce40ae7876b1c79480e6f502340d9c572cfd6b7ac5a75856cf"
    sha256 cellar: :any,                 ventura:       "dabcd68e29c8efe82ea9763f6a481568147bc50b02d04b6db6df0684b3f77b18"
    sha256                               arm64_linux:   "4e5427467da0b9ffb697dc68629c29663b98593a80146e01f75149cc6e2322d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a5318eccb15cd2ce95c016f3406eeef7957647b409c43875b194e83d8d6666"
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

    (testpath/"test.c").write <<~C
      #include <orc/orc.h>

      int main(int argc, char *argv[]) {
        if (orc_version_string() == NULL) {
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/orc-0.4", "-L#{lib}", "-lorc-0.4", "-o", "test"
    system "./test"
  end
end
