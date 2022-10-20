class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.28.tar.gz"
  sha256 "4df11d93260d3cd9f17c3697b0828d38400a8f87082183368df6a1ae7a9fc635"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f20ca71a41b3c3a3c648e4d3600e91ee87b87c66ef89ee33b4c04966cb42b4fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b142108d31d44af8d338ae68873c2b215860c592c6bf14ae2c074c6f1624737"
    sha256 cellar: :any_skip_relocation, monterey:       "9acafb56282cd618716bb4b2d262c2c65fbb98e4efd713c130b4b4fadb31a31b"
    sha256 cellar: :any_skip_relocation, big_sur:        "80dad8a52ceff398465dc0aa2c0a1cf4fd045cd0d82096c75e064d8fe2b947bc"
    sha256 cellar: :any_skip_relocation, catalina:       "29cb3c088a8b5ae9c8e6e0c24b57709245e17bafb7d3413f7869f3bdca914c99"
    sha256 cellar: :any_skip_relocation, mojave:         "d3bc6cbe15a957e620353e165589f81e1ae8065600bc696206efe6bc129cf8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f170f40ba5a030c9ac2e379a59f4a76020aa9a266f9a094deaa7d1c631180e5"
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
