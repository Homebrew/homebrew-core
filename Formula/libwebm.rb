class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.27.tar.gz"
  sha256 "1332f43742aeae215fd8df1be6e363e753b17abb37447190e789299fe3edec77"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1eb4f710924f50df98fc45e1f51305698daf70336198bdc74f551f2ea8e7edfa"
    sha256 cellar: :any_skip_relocation, big_sur:       "37c6bf256f4a45d3765d671c3a923875adfccd49d8c038ca1e07c6ba181341ac"
    sha256 cellar: :any_skip_relocation, catalina:      "548a7393b909a559e08fbd6a0783ada345e0ef08b59f9b44588cc99d4420a040"
    sha256 cellar: :any_skip_relocation, mojave:        "4238e3823e0e467e06492563d7f8c7603751419568ba621b6f644ad4ee5a30e6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0df7605cdc3aff926c0ffbcf5d72cf12933781083890eeeacc10df82b317b7c2"
    sha256 cellar: :any_skip_relocation, sierra:        "36f647efcc9d72881ad8998df30e3268ec0b69b81c872fc381e3d7126fa2da6e"
    sha256 cellar: :any_skip_relocation, el_capitan:    "784418b8fc6006788c3a7c867cf675532fb7b86299ff9f8fb85d946c2e8cbc38"
    sha256 cellar: :any_skip_relocation, yosemite:      "c6c99d02e47ed6ec17821ab9386e49b40ffad45e30f58fdbae62395dc16def18"
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "libwebm.a"
      bin.install %w[sample sample_muxer vttdemux webm2pes]
    end
    include.install Dir.glob("mkv*.hpp")
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
