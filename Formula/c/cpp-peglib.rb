class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "bfb85a43191a5bc50b4a067d3f9af71d7958450f706d1a128b345265a0cdfb7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70ec14fa81394d5485e34c090e20114665bec250287acbcff6f41a290ce82d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1959d59160f624c1b0ea0c39f7e3cc13c5a98d4f6b7c0c086613cf32ed2469d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee07e0e9d848cce25aa3d68b49a7c2dbbdf88a740a88222462f54518eb00ee75"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a404897191194273762c08df86842a6d4eb0cb3ecaae2bbdf757dbbe89de1f"
    sha256 cellar: :any,                 arm64_linux:   "27fec28070f61d8ab4f787435433ffbcc1d2dd208557dec9115a5ffc2ed42f9d"
    sha256 cellar: :any,                 x86_64_linux:  "723c2c0af52725df8e2af584e71b10dc54b7d353c55aad7e8cfd1d47adfde812"
  end

  depends_on "cmake" => :build

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
