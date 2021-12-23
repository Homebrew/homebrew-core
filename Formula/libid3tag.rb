class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://github.com/tenacityteam/libid3tag/archive/refs/tags/0.16.1.tar.gz"
  sha256 "185a6cec84644cf1aade8397dcf76753bcb3bd85ec2111a9e1079214ed85bef0"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "0820b023a1ccf3d8fdb1270e91c8207b737e725040f94826fd0fe49081279b0e"
    sha256 cellar: :any,                 arm64_big_sur:  "cd7f36377060c5d16d3ee4d4ef5696ef47be82f4f0807172eef36f589cfad246"
    sha256 cellar: :any,                 monterey:       "34689cc3eb433e97b321ba57a43182f87cf84b3e2ccbce9614913f9dc84c2d73"
    sha256 cellar: :any,                 big_sur:        "ef38d5804e95cf7f2096c9e8ec31e568170c6e238e43e7ddc3df914ded26f07b"
    sha256 cellar: :any,                 catalina:       "93b071dac99b3d85dac56e59af42e28d5de959bed9fd37a9a2178c02c8b20f17"
    sha256 cellar: :any,                 mojave:         "1186600473728830dbb65189d11912e2abf42dac5fcbf7ee38629784cc83b310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0ac4078c55cddf2f6bdb55ba09e81f32d982b0e62c27301d232627a0f31531"
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
