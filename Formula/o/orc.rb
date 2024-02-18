class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.37.tar.xz"
  sha256 "85638c0d447d989cd0d7e03406adbfbc380e67db2a622a4727a0ce3d440b2974"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "24d469af7ac8f37f02b89de49f626ce21ce291bd086e36a07fc0e96f8e2aebdf"
    sha256 cellar: :any,                 arm64_ventura:  "4dbaa0ad27bb3674615457ff111948f51ce3e70d8266668739538ec217c2ae73"
    sha256 cellar: :any,                 arm64_monterey: "74a44b037797650f5067cf3b9ed04ad5d400fa126804b4870077d9c59225f0d1"
    sha256 cellar: :any,                 sonoma:         "7a36963968a647c18ecddf78147b60b6114f01618609384d884bd2088ea072df"
    sha256 cellar: :any,                 ventura:        "f7c837c36a99748e37273a5274f799efdaf46b40eda006ca11819893ae68525b"
    sha256 cellar: :any,                 monterey:       "3db8247c8eba3c22bfd9beb1fdeab1d1db40a7659ae2efb7c76d8142a3fff67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a843196c3e9b6c7c7cba7ff11ad319b53d8dcd86dbffe240d5effd3fb5b47e"
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
