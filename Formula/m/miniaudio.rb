class Miniaudio < Formula
  desc "Audio playback and capture library"
  homepage "https://miniaud.io"
  url "https://github.com/mackron/miniaudio/archive/refs/tags/0.11.25.tar.gz"
  sha256 "b900edcffe979816e2560a0580b9b1216d674b4f17fbadeca8f777a7f8ab0274"
  license any_of: ["Unlicense", "MIT-0"]

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DMINIAUDIO_BUILD_EXAMPLES=OFF",
      "-DMINIAUDIO_BUILD_TESTS=OFF",
      "-DMINIAUDIO_INSTALL=ON",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <miniaudio.h>
      #include <assert.h>
      int main(void) {
        assert(MA_VERSION_MAJOR == 0);
        assert(MA_VERSION_MINOR == 11);
        assert(MA_VERSION_REVISION == 25);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/miniaudio", "-o", "test"
    system "./test"
  end
end
