class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/refs/tags/2.0.1-7.tar.gz"
  sha256 "941f1347dabab02c88ef57e225b04587c3f69824e550e1045e4a9119cd657a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7fa51b262723750c0393660e45d6fa7e3c049f903e17d75f5814cfb5a8bbf5ef"
    sha256 cellar: :any,                 arm64_sequoia:  "120bc6b9f88b42a4bd852c1ebe9d236d94d40edae13e06cec4906905347580ee"
    sha256 cellar: :any,                 arm64_sonoma:   "74d5dc6d43cb2ef587a861a8b784ec6134c86f73149645c653b5542c3a0941b6"
    sha256 cellar: :any,                 arm64_ventura:  "700fd8255a363e2e28aa5b801c4e3218bab3a78f0c37f16dfa60f0e2337146a1"
    sha256 cellar: :any,                 arm64_monterey: "9726d67b4c9b83077d508a64067df3eb96f87dd731a3cb08395a68dbb2234d88"
    sha256 cellar: :any,                 sonoma:         "fd982bcdc2ab3d9ec3e0a714295a41d1568a51a6f050d01314bbb9822505549a"
    sha256 cellar: :any,                 ventura:        "d7edd4161e6b2ce4eb239cacd3264a23aa8c9a6cd89683f0a6bd96b757120672"
    sha256 cellar: :any,                 monterey:       "997f4179c3fbde9beb699106367d0c944d3ddbb9fbd5c4744cb31e6f7f1ba72b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f30bc80b540e0150e47fd34157068ccd2734dcdcfa4a9f90768a1d4e9fb00213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e1b9e90eb51ce8918bf817febf0bf785da0941cb793a430e8299492bdaafa4d"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <soundio/soundio.h>

      int main() {
        struct SoundIo *soundio = soundio_create();

        if (!soundio) { return 1; }
        if (soundio_connect(soundio)) return 1;

        soundio_flush_events(soundio);
        soundio_destroy(soundio);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lsoundio", "-o", "test"
    system "./test"
  end
end
