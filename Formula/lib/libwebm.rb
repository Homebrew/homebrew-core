class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/refs/tags/libwebm-1.0.0.32.tar.gz"
  sha256 "7fd5e085bda9f8031cf2ad2a1e52d9b7b29cba9c0b96ad2ce794ce89e4249eb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bd6613c74dd44b41084c070312f2eda8d419fe657f98b4f86d29d02626a92ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325dddc229395db23b900a46264df1437b31af109a4fa3a8c488eee5dff1aa7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7afc749ec4d49cd5853f62861df3cfdac04caebd77478def12e69f97b2a52b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3db90115b86d8d78e0630f7954167262a3caacf0ec71f1f8e8549d7a87dbecd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccf6f6d11126683575f1eb158e8b0fe562a3b12594970114746751f1418b4dc3"
    sha256 cellar: :any_skip_relocation, ventura:       "2a1a22a88f4f5841edbfcd0147dca26f323e8d00f8c6e51b5ac163c6470e334d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04dd0c252829a72f8f70f14c0a4f250a71e439770db4718198618e9016afbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc19451f040265923fdc0413c0f78769872338ddda782625ff9a567c6c3be2f6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "build/libwebm.a"
    bin.install Dir["build/{mkvparser_sample,mkvmuxer_sample,vttdemux,webm2pes}"]

    include.install Dir.glob("mkv*.hpp")
    (include/"mkvmuxer").install Dir.glob("mkvmuxer/mkv*.h")
    (include/"common").install Dir.glob("common/*.h")
    (include/"mkvparser").install Dir.glob("mkvparser/mkv*.h")
    include.install Dir.glob("vtt*.h")
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mkvwriter.hpp>
      #include <iostream>

      int main() {
        mkvmuxer::MkvWriter writer;

        std::string test_mkv = "#{testpath}/test.mkv";

        if (!writer.Open(test_mkv.c_str())) {
          std::cerr << "Failed to open the MKV file." << std::endl;
          return 1;
        }

        writer.Close();
        std::cout << "MkvWriter test completed successfully." << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lwebm"
    system "./test"
    assert_path_exists testpath/"test.mkv"
  end
end
