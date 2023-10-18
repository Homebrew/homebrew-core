class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://codeberg.org/tenacityteam/libid3tag/archive/0.16.3.tar.gz"
  sha256 "8cebfba0a7cdf4fada8b715fc17a29ddadd825448da05db006e18acd8bc2731d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ed10109e8ae30da194fe62e3a71bee568b0cde84e78c0e9bbeaafed93e0927b"
    sha256 cellar: :any,                 arm64_ventura:  "0ea24c45073d3e7a8b939a1776d4fafcf6bb8072c9d2107f5b5e9903d2a18564"
    sha256 cellar: :any,                 arm64_monterey: "c632b8be47cc5f122745b4e6c0948d56cee499c276f7b6ced2f479f078dae8ad"
    sha256 cellar: :any,                 arm64_big_sur:  "9f9f8eea108670fd8d9f1bbde465e49543fb09926d0699bd03e03ad4ce4a4059"
    sha256 cellar: :any,                 sonoma:         "c544219bae9e69ac20915abf32abcef7b8a5b4f702eb13d508dab3914fd992e8"
    sha256 cellar: :any,                 ventura:        "1b6387129a1f3dad504548c0dc6c686e2d8478cbe4c759609780af7eba72466e"
    sha256 cellar: :any,                 monterey:       "7878d7bd1222ba5e6bfd588c7a8f37eb37e008de6a6c8041846de9d3175b3528"
    sha256 cellar: :any,                 big_sur:        "3fcfb9567c7f844e56d3844c951452eaf9a074019732b0768bd64daa3a5e7766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5174d49cb919793e71f1c5cf3609a3c717e1f047d6360aa183830943c5e3a8b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  uses_from_macos "gperf"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <id3tag.h>

      int main(int n, char** c) {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
