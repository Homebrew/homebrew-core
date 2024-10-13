class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "https://github.com/libsndfile/libsamplerate"
  url "https://github.com/libsndfile/libsamplerate/archive/refs/tags/0.2.2.tar.gz"
  sha256 "16e881487f184250deb4fcb60432d7556ab12cb58caea71ef23960aec6c0405a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5fc173532c2b6fce115a5e36266da6c2dab4b4508478132790befa5f0342199e"
    sha256 cellar: :any,                 arm64_sonoma:   "dc278cc14c1b7bfe2530935297bb3ab56d162420387702a38def3aaa26e03181"
    sha256 cellar: :any,                 arm64_ventura:  "3e9b241d45526b794f8f2a5873b1377ba909532da1bde00a235c8949edde1366"
    sha256 cellar: :any,                 arm64_monterey: "f9e2a83582d3ab964fd92d0aee6acffe5b73ab8981d80d4119beb1b45210f4ce"
    sha256 cellar: :any,                 arm64_big_sur:  "3093453ad9b90daa071d033cfaf5e6cafe8963350130ef26741a1c9d1c4b5659"
    sha256 cellar: :any,                 sonoma:         "701022edab06b57aed672ab9f1c6791f1ee3c7f538215fd4f65ea6e1cabad171"
    sha256 cellar: :any,                 ventura:        "85204079adb4d9070ead5ce096f7338a8c921fa108f65560256b23a7311d4a02"
    sha256 cellar: :any,                 monterey:       "de43a6d8b43091b2f76d367409e7bcae60599e13875166c58c50443f0d336e91"
    sha256 cellar: :any,                 big_sur:        "58ef6e20fc12580743d91e00fb349b1160fff0de49028b7c90903245605c0ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d59c68d8d1f510237381994b7eab99cfc1d99113c5cd5ced3d0bb460faccaf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
      *std_cmake_args,
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBSAMPLERATE_EXAMPLES=OFF",
      "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build/shared"
    system "cmake", "--build", "build/shared", "--target", "install"

    system "cmake", "-S", ".", "-B", "build/static",
      *std_cmake_args,
      "-DBUILD_SHARED_LIBS=OFF",
      "-DLIBSAMPLERATE_EXAMPLES=OFF",
      "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--build", "build/static", "--target", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <samplerate.h>
      int main() {
        SRC_DATA src_data;
        float input[] = {0.1, 0.9, 0.7, 0.4} ;
        float output[2] ;
        src_data.data_in = input ;
        src_data.data_out = output ;
        src_data.input_frames = 4 ;
        src_data.output_frames = 2 ;
        src_data.src_ratio = 0.5 ;
        int res = src_simple (&src_data, 2, 1) ;
        assert(res == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{opt_lib}", "-lsamplerate", "-o", "test"
    system "./test"
  end
end
