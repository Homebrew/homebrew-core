class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "8a82dac0b83882ae808b2678fdb1860dd0924235ce482543c1d9d01fe3a065ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e4b38bfebf193d483f3c5e9c89dad9aefd0d5df7b8864625def5c791a180a4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f5f0f2c87033962979689a919e9bc8c82f52665373a5e2e5abb96c08edf65e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0123e185683d9fd3edfa9409532310288750a20d94ec3b429d9a3991d832ab2e"
    sha256 cellar: :any,                 arm64_linux:       "dc3e93f5495915a2ea2d5196fffe84711e8415129a3da689fe7a3d05b0109737"
    sha256 cellar: :any,                 x86_64_linux:      "e7d8b99e18d2ec35da7313cfd0a3a60c7d204991758efd5556ac843dcd7bcd6b"
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
