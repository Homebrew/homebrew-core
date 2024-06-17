class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/refs/tags/libwebm-1.0.0.31.tar.gz"
  sha256 "616cfdca1c869222dc60d5a49d112c1464040390e3876afca4d385347c6ce55e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdcfe9ac4d4a025957c618aee58539cad66931b0d74e17f05b049337cbebe651"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21a08a2111b19d647ae24038c95ebafe8bcfb2db68d512e3e84615b27bf85c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6233852ce953b18eb356b7af0f5433984d770cfa50a9bf067a67469e9a4aa489"
    sha256 cellar: :any_skip_relocation, sonoma:         "25960105fc505deab8de42959a2586cf14ae0aafb8fe8bce4ffcb389b43badd5"
    sha256 cellar: :any_skip_relocation, ventura:        "a6dedcb3fb10cf5363a2cd18f95c62fb8e35f4383f524d29f08541c9f9bcd26d"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9bce06869370b1e3222777fb5c29fe9f1f9f281f4a830e45b7f3e37441b64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca54a3fe3b38d5c2ccb316ab18779dfa6c7fa5b4d9533be5be3cb5bb822e64f"
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
