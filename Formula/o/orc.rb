class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.40.tar.xz"
  sha256 "3fc2bee78dfb7c41fd9605061fc69138db7df007eae2f669a1f56e8bacef74ab"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "90d8de016969328e2eb572eb108829b849cda780cefdb98b44704d5c8df456b9"
    sha256 cellar: :any,                 arm64_sonoma:   "1c01024d793b7feae787a50c02e779a2337a82c084c8752cd6d06f8f97d66a6b"
    sha256 cellar: :any,                 arm64_ventura:  "f1cb98a80bbce3c51266b084be2c0175193486e98eadc0ae2320289e07f86697"
    sha256 cellar: :any,                 arm64_monterey: "6cf3477904bb788dae6bc48425c320c9b5734247842ebe055cb7e625ffb0c73a"
    sha256 cellar: :any,                 sonoma:         "59c5af370c421275f0b6aadf7f9d485593a2444a78bc370a9161e98dc1b8c933"
    sha256 cellar: :any,                 ventura:        "017b065a46f040be148fe0f090c429a6b368df32b3f70d71d7504c9bec7df8b0"
    sha256 cellar: :any,                 monterey:       "6f514f984e8a37cfdb16c94368bd9a108e42cbeadcdbee3331cce47e8c1ffe32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b34751604d245a523fe1b243562bb0b5428ca45d1ce6d6101fcf5fdf92d3584"
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
