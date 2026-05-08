class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "af654d345788715754cee3757433837620aed38a2efc30a3e94ee709bf407ba0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb37599871adee16a00f15c014d48a74d38e043e65ac8f3884f7edb7923dd65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1c3fe28507d8b38d77a31bcefde790df6a4b6def12d4a110d7e0247ec92669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c7471d8a73dbae1641036d31f8f03a32d51280a79eb14d5a693775f0289ef49"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7065393cef1c64623194ef19a7c7435871e15ac80c473e162bd7dd2d0de61a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1caec85ad4d8455a6200db1285820e62580e9eae8f5c6f1f99826b64030a4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ac901f1488ce1d7be943728a908457a4e31b4a397e770183147a2866888f44"
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
