class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://github.com/tenacityteam/libid3tag/archive/refs/tags/0.16.1.tar.gz"
  sha256 "185a6cec84644cf1aade8397dcf76753bcb3bd85ec2111a9e1079214ed85bef0"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2464c33c9031a7de18c5d3328e9f34ec6b8a0d14b83339f8137e9d8ace8689e"
    sha256 cellar: :any,                 arm64_big_sur:  "5131938bc5b5877f75de69be030893d5b0a31e252d36e9579723f7370f5b8bee"
    sha256 cellar: :any,                 monterey:       "790f7ef2e0cab3a2c6552728d06843b5c490da42cca1e5ef34e76a110a2ed5f1"
    sha256 cellar: :any,                 big_sur:        "1f3fba83270f945e708fbe4b935608aac1564c57f04ada6077ef4c73aa12ad37"
    sha256 cellar: :any,                 catalina:       "203fc54e1c97e801e3a5c38a094217fefc60f5ee613b8dd662981b8a77ed3848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e1a4d5bdf7328cd39d9eab69d04bcbb9d509b1f479a022b30487058898b0cd"
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
