class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.30.tar.gz"
  sha256 "6c1381fd1a66e86e095b76028ede696724e198ea0e39957c9649af5f0718b96a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97a2d4d78fc365ad2a2b1219597e24e0c99fecfb001d59ac909490919886659a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a99910e4e7c3eda52063a5ce8af1ceca221e573ac750e4a44e10d72e409034bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad40f80c6ab3251c8a15d4b69237da7903861605f83077277d6784451fb1ceda"
    sha256 cellar: :any_skip_relocation, ventura:        "bad46316d12e5ed6115667c97d0bbcdf559dfc518828c9d3609bcc39fc4e2ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "10d205ec71e3bab053c06c0f8cbadc27a64ad8c4d383c8e2876dfea9da1d5af3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd560f1cb7c59441fbb5251883718af0fa39569e2d3abb4066926f6290d2eb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73347ce7d3bb4f6c28d61a31bf3c7362c332394d772559480a4b813578267d2e"
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
        mkvmuxer::MkvWriter writer;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lwebm", "-o", "test"
    system "./test"
  end
end
