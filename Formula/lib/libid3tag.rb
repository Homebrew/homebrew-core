class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://codeberg.org/tenacityteam/libid3tag/archive/0.16.3.tar.gz"
  sha256 "0561009778513a95d91dac33cee8418d6622f710450a7cb56a74636d53b588cb"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "bf039c13ec5c83ddad086ffc8d351ceab2c7424d7ee91804de65c736787ca07c"
    sha256 cellar: :any,                 arm64_sequoia:  "511a214c725978fd5596e7bb1a4c1b9846d3f95a59c1da05aa49ac687d997d07"
    sha256 cellar: :any,                 arm64_sonoma:   "ddcf954105ff32bf933c7989b29b275c73eff81c6f036aae28646aa282b2d693"
    sha256 cellar: :any,                 arm64_ventura:  "cb4c5b313fafc30aa641a61fb0aa8b84b8c7232d7eea9e6d55c486664d129dc2"
    sha256 cellar: :any,                 arm64_monterey: "1dc3d797b3838163199a5496cad1018c204c87559292dd716b309acd33b780d5"
    sha256 cellar: :any,                 sonoma:         "09c2bb42b12b186cce68cc20388585b26452eb75a39caebaaefd7c36beb9460e"
    sha256 cellar: :any,                 ventura:        "2fea4c1d71287947cf0bbb995782f610c671608f811bebcd2f1f80e5a137705a"
    sha256 cellar: :any,                 monterey:       "1569b5187d5108de0a9fa10ff46c87634e5a6164dcff622aa5b46d0084db50ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "238671fe5e115d97846ea8b1d07d23970451659d2fd169b26f6854eec2cbf858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9833f57ba6eec9cc19fdc34e93077cd21ec11636320aad4d9945196a7cd69f7b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  uses_from_macos "gperf"
  uses_from_macos "zlib"

  # Allow build with CMake 4.0.0
  # Remove on next release.
  patch do
    url "https://codeberg.org/tenacityteam/libid3tag/commit/eee94b22508a066f7b9bc1ae05d2d85982e73959.patch"
    sha256 "f4278e88cb23b0a2aa2bb2c074c6fc2e61029b6d0d77856f4439c3f75f888cbc"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <id3tag.h>

      int main(int n, char** c) {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
