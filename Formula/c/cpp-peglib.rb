class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "5bf1b6bf854e9751658ec85a7cba1beeb81fa6a6baff2af6369a2e1be0a2b99a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caca4fe3027f1b10d122d43095fc7d90c2c56c84c0b4721c037ab6d7e8471243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0957743cd61a759d323af61c1762872dc2b5223e93a505fcd2d3a99438761b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51e39417909136911ff6e2586f0e7ec320b8a06587667606800617ad50ad212"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cad0a0a27cb4d68f0b146f60a8ab118d690866c1c752ca00c6aa74a554c533e"
    sha256 cellar: :any,                 arm64_linux:   "8eb7c2c797530a76ec5203772a6ef0c01b5708511d31d4a9cd8fd0ae1f05980e"
    sha256 cellar: :any,                 x86_64_linux:  "3385c57506f1cfce1281a86957584b7cdc862f7fd72ec14d49019e3ef53f386f"
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
