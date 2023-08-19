class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://codeberg.org/tenacityteam/libid3tag/archive/0.16.2.tar.gz"
  sha256 "02721346d554c4b4aa3966b134152be65eb4df1fb9322d2d019133238d2ba017"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f881ed95a669df1c88dca0c60fcf2eee77a752884a3e2b6332b70cba9d51f2f9"
    sha256 cellar: :any,                 arm64_monterey: "bafa60c5f60c3f181eaf53ff64acae1cf04cb3600a49755f0eb7a589ad2f6b0f"
    sha256 cellar: :any,                 arm64_big_sur:  "05d1ea6709e912c43d07043476aab2ddc131198215bcf2caffe3a1c5176a6d7b"
    sha256 cellar: :any,                 ventura:        "2dfe1c49fc68e3ea8e18a456775282288158ae32f0d61d659ce1a8b3d70b3ff6"
    sha256 cellar: :any,                 monterey:       "86d3dbe6f29ca5cc9ccd255c2c488c2267d2fa3bdcada964b25d3cf6014d0701"
    sha256 cellar: :any,                 big_sur:        "d37b4456d86459e44c6784bb0c722f15bf59f558905c3c17edfd8537d80d141b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78951ee4f80eaec7f2d958c790612e6f7edcadddc7a38f2c89c24438d0eeb48"
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
