class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.1.3/libaec-v1.1.3.tar.bz2"
  sha256 "46216f9d2f2d3ffea4c61c9198fe0236f7f316d702f49065c811447186d18222"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cdf50fb48fbe330bb9b925c8c77db35184d72153fcfa5b35e44f8af7fd043167"
    sha256 cellar: :any,                 arm64_ventura:  "039a503bf9b043b1bfa509291887e083a11656169d27570b3fd5aa5c6dce203d"
    sha256 cellar: :any,                 arm64_monterey: "e01189e1d9f536cb14b7bb52b3714161c270a4e3decd180d9b7fc00109b98a4e"
    sha256 cellar: :any,                 sonoma:         "ecc061efd6237f7e8f2b075cb3c878798bf344a9e882d9b331787bbabb8a9616"
    sha256 cellar: :any,                 ventura:        "5f42304a1ff88ca94ec7ff8f8e2f7ccdc9910312823a61f4ced2b60f61f4115a"
    sha256 cellar: :any,                 monterey:       "9624bac0ca98f63c38fea833d383559f0e43110b50a24cab4e3e99861495de59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aabeaeb8f71d4810ed9ad0ad375785878f1efd7515556f11fec3045c3be02c8"
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
