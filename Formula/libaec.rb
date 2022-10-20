class Libaec < Formula
  desc "Adaptive Entropy Coding implementing Golomb-Rice algorithm"
  homepage "https://gitlab.dkrz.de/k202009/libaec"
  url "https://gitlab.dkrz.de/k202009/libaec/-/archive/v1.0.6/libaec-v1.0.6.tar.bz2"
  sha256 "31fb65b31e835e1a0f3b682d64920957b6e4407ee5bbf42ca49549438795a288"
  license "BSD-2-Clause"
  head "https://gitlab.dkrz.de/k202009/libaec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "efb772c032399b490e5ba1f197e5cbf07efa3f9a83994ca770790f748a659587"
    sha256 cellar: :any,                 arm64_big_sur:  "435271c305d6e1dcc07de9875dc3dfc8a0c6527a22c942e4961cabe49d8e75c3"
    sha256 cellar: :any,                 monterey:       "2d40180340fb2ac382a9324d049dde7ab47f13d9ec812c9df6656dbd0ea91ffd"
    sha256 cellar: :any,                 big_sur:        "1dbb32dfbf75c7abc923f53a8ebfcbfca74426c2386521b424ce84232e3ce0ac"
    sha256 cellar: :any,                 catalina:       "8fb8196910a91e85aaa1343f904ffbc3e3e0565774aab6d4ab6455cd1795dda8"
    sha256 cellar: :any,                 mojave:         "540f342390a38bb62dad9ccaca77890be88d903bd3092c17054b692eee8b7120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7b059adad11a2a31efa3331663189c7800af8666843b22c9cc7ccf4add762a"
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
    system bin/"aec", "-v"
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
