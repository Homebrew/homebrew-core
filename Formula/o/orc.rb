class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/modules/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.44.tar.xz"
  sha256 "4aeb97aea2b58224029dc2b23d7d064cfa990cb4fb8c4da440bcbe9c95bc5d2d"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "21bb6e15481ce8c8faf8214fe7cc2042a258fb09697e26249b733045d327b5df"
    sha256 cellar: :any, arm64_tahoe:       "4b326411003fdddfd8bf3dea9815043d962e748b6fd550be1322e1c6d2afd38c"
    sha256 cellar: :any, arm64_sequoia:     "f491eb26689b8f223f4681cdd85da4342a7c9504da4380ee99d3f23938df3430"
    sha256 cellar: :any, arm64_sonoma:      "5c7ffa0ab1653adb2b6ef67425df8c312a47999740c2659fcf7e7f22f10d1d76"
    sha256 cellar: :any, arm64_linux:       "24687a69229796ddff114dffb92f800b37860622a48ba8379716363909ba3d46"
    sha256 cellar: :any, x86_64_linux:      "6b14ed765346e7753fb5d6c5249addc0dcf27e128b279f4431ddd7f6f66eefbc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
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
