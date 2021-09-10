class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.0.5/libaec-v1.0.5.tar.bz2"
  sha256 "49cc260c3321a358a8d854444584eec58382c26cda3c4bcd156b4ba396075ae7"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eb75225b84ef78247e6313d9898d42f257012d406900b13a10e796150129d6e5"
    sha256 cellar: :any, big_sur:       "2b7e11d1e50b73f63081c492a25a9778c82d552ef49d9738d716402c22278a44"
    sha256 cellar: :any, catalina:      "f710bc0d08883c62af1d6021ec59294bd495fa1a9bf5411b533c058492949061"
    sha256 cellar: :any, mojave:        "bfa7e201aaf1d16c44ca6607b553d5c2b6671eecc9d14fd70b9eb957033afd06"
  end

  depends_on "cmake" => :build

  conflicts_with "szip", because: "libaec provides a replacement for szip"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      system "make", "test"
    end
  end

  test do
    system "#{bin}/aec", "-v"
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cstddef>
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-laec", "-o", "test"
    system "./test"
  end
end
