class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.3/libaec-v1.1.3.tar.bz2"
  sha256 "46216f9d2f2d3ffea4c61c9198fe0236f7f316d702f49065c811447186d18222"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c226a16104f6c585188316a0873bd793c71721f5c39648a346648d5a05a28d3c"
    sha256 cellar: :any,                 arm64_ventura:  "d16c49cbbc3255ee5acdf072ac7803bda2f25bdaa3feea465ad3add3abc882fd"
    sha256 cellar: :any,                 arm64_monterey: "c70deb367fb14342dae88999341df49e67ee77198c0c3b46b18d087923228664"
    sha256 cellar: :any,                 sonoma:         "f75484ecbbd01f45417f8a1e4994d6ee8c814cabac6bcf799b183fca13184670"
    sha256 cellar: :any,                 ventura:        "e7100d69258e016d8840ee20ee61367f1c48df8f42c3d19b1c0ab67404658a8d"
    sha256 cellar: :any,                 monterey:       "91b09dc81cfa80f1d2c9dab7b17d471225fc11d93bb9631a6ac8cc9e506735bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d3097aa577be93f7d534d6460fc190fc7234a77f34c561ef44d59a6e57d539"
  end

  depends_on "cmake" => :build

  # These may have been linked by `szip` before keg_only change
  link_overwrite "include/szlib.h"
  link_overwrite "lib/libsz.a"
  link_overwrite "lib/libsz.dylib"
  link_overwrite "lib/libsz.2.dylib"
  link_overwrite "lib/libsz.so"
  link_overwrite "lib/libsz.so.2"

  def install
    mkdir "build" do
      # We run `make test` for libraries
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=ON"
      system "make", "install"
      system "make", "test"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cstddef>
      #include <cstdlib>
      #include <libaec.h>
      int main() {
        unsigned char * data = (unsigned char *) calloc(1024, sizeof(unsigned char));
        unsigned char * compressed = (unsigned char *) calloc(1024, sizeof(unsigned char));
        for(int i = 0; i < 1024; i++) { data[i] = (unsigned char)(i); }
        struct aec_stream strm;
        strm.bits_per_sample = 16;
        strm.block_size      = 64;
        strm.rsi             = 129;
        strm.flags           = AEC_DATA_PREPROCESS | AEC_DATA_MSB;
        strm.next_in         = data;
        strm.avail_in        = 1024;
        strm.next_out        = compressed;
        strm.avail_out       = 1024;
        assert(aec_encode_init(&strm) == 0);
        assert(aec_encode(&strm, AEC_FLUSH) == 0);
        assert(strm.total_out > 0);
        assert(aec_encode_end(&strm) == 0);
        free(data);
        free(compressed);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-laec", "-o", "test"
    system "./test"
  end
end
