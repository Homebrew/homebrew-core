class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://codeberg.org/tenacityteam/libid3tag"
  url "https://codeberg.org/tenacityteam/libid3tag/releases/download/0.16.4/id3tag-0.16.4-source.tar.gz"
  sha256 "8b6bc96016f6ab3a52b753349ed442e15181de9db1df01884f829e3d4f3d1e78"
  license "GPL-2.0-only"
  head "https://codeberg.org/tenacityteam/libid3tag.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "100a58c3e4e26404d62e85fcabe8d0b5ba411094db8c97c46be1d916f95524ca"
    sha256 cellar: :any,                 arm64_sequoia: "648b4d4cd348899aca1edeb95d63f3039083fe86319ac3c502e929fafa2388ce"
    sha256 cellar: :any,                 arm64_sonoma:  "05c43972f0fffabb9b0868391f43e23238e2041faeaf179dbd9318468468ec37"
    sha256 cellar: :any,                 sonoma:        "b3c1ed4dfbe28dedb19408cdd3fbddab9beb38ab3268b01585418a0e694bbcdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f3757644b9124896fc61ecdc425b351cea0086a4268979925be50fca2bb5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ebccce6746bc7b0ce3cbd51794cb119ff4b1a5a3c7713ba20567744261b062"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <id3tag.h>

      int main() {
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
