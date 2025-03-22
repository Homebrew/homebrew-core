class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/refs/tags/libwebm-1.0.0.31.tar.gz"
  sha256 "616cfdca1c869222dc60d5a49d112c1464040390e3876afca4d385347c6ce55e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "49e659cf7620ec30ffecd7654da70d28120cd409ae68d7a48a646d2e57bcba1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdcfe9ac4d4a025957c618aee58539cad66931b0d74e17f05b049337cbebe651"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21a08a2111b19d647ae24038c95ebafe8bcfb2db68d512e3e84615b27bf85c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6233852ce953b18eb356b7af0f5433984d770cfa50a9bf067a67469e9a4aa489"
    sha256 cellar: :any_skip_relocation, sonoma:         "25960105fc505deab8de42959a2586cf14ae0aafb8fe8bce4ffcb389b43badd5"
    sha256 cellar: :any_skip_relocation, ventura:        "a6dedcb3fb10cf5363a2cd18f95c62fb8e35f4383f524d29f08541c9f9bcd26d"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9bce06869370b1e3222777fb5c29fe9f1f9f281f4a830e45b7f3e37441b64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe3eadf731b1ff0e1fea5a69a77f88e9643f6c27ce60202f80c583494b607fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca54a3fe3b38d5c2ccb316ab18779dfa6c7fa5b4d9533be5be3cb5bb822e64f"
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
