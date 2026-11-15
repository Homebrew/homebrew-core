class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "78cf9fc9110af3775c967592f5269563e6f8ee21024eb3d81a572bc0866fcb91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b458d4471bddbab8797ff8bc628a0e366c1597ef68d8f9a51959f52b12fbff2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce0dc0b0b72b00b317fb7db2f0ae4521c045f6cfd081a75defe87a70390526f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea4e4572d1b7ece429d2bc620dd62b66b889ec0df10eeab5a56f97fd0032ce7e"
    sha256 cellar: :any,                 arm64_linux:       "341272153d639ca4f576063c30af7b418d8806cb1ae2a188a0ad580b48e3e461"
    sha256 cellar: :any,                 x86_64_linux:      "bc0e8f9a24a6bd27bc50fbf8c1a5e066d235e5c7c8d3c4c553ef9fc3e6cf5e30"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DPEGLIB_BUILD_LINT=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/lint/peglint"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <peglib.h>

      int main() {
        peg::parser parser(R"(
          START <- [0-9]+
        )");

        std::string input = "12345";
        return parser.parse(input) ? 0 : 1;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"

    (testpath/"grammar.peg").write <<~EOS
      START <- [0-9]+ EOF
      EOF <- !.
    EOS

    (testpath/"source.txt").write "12345"

    output = shell_output("#{bin}/peglint --profile #{testpath}/grammar.peg #{testpath}/source.txt")
    assert_match "success", output
  end
end
