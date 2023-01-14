class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "https://github.com/libsndfile/libsamplerate"
  url "https://github.com/libsndfile/libsamplerate/archive/0.2.2.tar.gz"
  sha256 "16e881487f184250deb4fcb60432d7556ab12cb58caea71ef23960aec6c0405a"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1520ae5ea1977615402b3f16329b1ee932fe169b993915646968dca22623d4ad"
    sha256 cellar: :any,                 arm64_monterey: "5ef2feb5aa853f321b4b87fc7cde27d2fd34c2a012ca6c46b433dde006f3561b"
    sha256 cellar: :any,                 arm64_big_sur:  "15a9996d530a20df675b808e5cd2d90c506f419c083f0deeb7c361cb6776733d"
    sha256 cellar: :any,                 ventura:        "f0bf3364c86bb5a067a8e9fbd13f4a4ced20d7c5dda70115f551903f8cf8fe53"
    sha256 cellar: :any,                 monterey:       "a4e347a4bcb4b62abc7e33110e8f3fea56e621d26d98e254c17d6e7e61049a81"
    sha256 cellar: :any,                 big_sur:        "1181186b50d4232509d88f4f8f7fe8e016adb220cc529c5cc84b6d91abaef08c"
    sha256 cellar: :any,                 catalina:       "36215e2af706686ca333a685a08121d4516d831d0ab99e4188002b7ceb5886c9"
    sha256 cellar: :any,                 mojave:         "cf0ae6a23af23ce858c7c4301e3c487013d46bca1859cf2b5642068a3b7da861"
    sha256 cellar: :any,                 high_sierra:    "6003a546793b85dcba886124b962a3ea332ea35cacce64a1cb1af9af94437807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc57fd09a0d20d887a9c12042d5c0ba395e801a8f4fe7e5faba121f0cfc2a84b"
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
