class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "78cf9fc9110af3775c967592f5269563e6f8ee21024eb3d81a572bc0866fcb91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5df416fc92450e3330b289b2a0068d805f8fed7e47c4814721d069d777d8ffe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "243f1d3849ae3d355e6a96482d45be7b914b370b656b0192363d6712b521c194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5567f4fd8fa7986994d25ef1865d8a7c47e35e2dedb6bf17d675f14204070ff"
    sha256 cellar: :any,                 arm64_linux:       "202958e240115eb95a207767cd9d4663283d2d0123ff033218a883fa1e0c11cf"
    sha256 cellar: :any,                 x86_64_linux:      "158d61aefc9d6157d21c66ab571ed927de5d1b5165cc6da27838753dcaa5ea41"
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
