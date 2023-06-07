class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.29.tar.gz"
  sha256 "a07e6640906e0c7fd3c6274b9bf3e9872bd36729bfcc0b83776d90e52e257521"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b1aa24d7987848c0eaed01677a8aa43ed5a25ad6cb8112cd9fe26dc4f5a8979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1e7b5dbdec1d5884a5ee92b5bc098b5fd2e911a9d218c4e992bdaa7aaca79ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "574332df969832fb035d8b3ff92c4515d9dd45587a4f6059682e4e61f7819d58"
    sha256 cellar: :any_skip_relocation, ventura:        "a030f71b730055f2341e61adafa1fa9ebd116d2bee4981d24a57b3cd99583f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "1015e20fc36269d59ac420f7bc8d1ba3b68317ee1858110161c4d973d747e93f"
    sha256 cellar: :any_skip_relocation, big_sur:        "30b3141f65985fa8fc647a14e82d0e0bab68bcabd2247bd4e62e649a53f67545"
    sha256 cellar: :any_skip_relocation, catalina:       "9afec9a609be6c0bb73d68dba00e30cf8a9dab0cb1927ec6caa1c153027c28d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034f77bfc1b83506d526e3f441ec544a09b5b5461e7fb0e37bb58223d9bf80d7"
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "libwebm.a"
      bin.install %w[mkvparser_sample mkvmuxer_sample vttdemux webm2pes]
    end
    include.install Dir.glob("mkv*.hpp")
    (include/"mkvmuxer").install Dir.glob("mkvmuxer/mkv*.h")
    (include/"common").install Dir.glob("common/*.h")
    (include/"mkvparser").install Dir.glob("mkvparser/mkv*.h")
    include.install Dir.glob("vtt*.h")
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mkvwriter.hpp>
      int main()
      {
        mkvmuxer::MkvWriter writer();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lwebm", "-o", "test"
    system "./test"
  end
end
