class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "3ba50bdc1be5521affc507e9fa589526372f6d7396ec490f706255a2b30d9635"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "610891314ff4a9a889aacf9135d223a3fbdf25212cb0c549b567467cfeaf10f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9d3ab13ddb41c1e9bbcdfde53b2beed27c106276f5add43c333caaaf3bafe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e7d704a75d814454163da99fbc84eb67d1e953577d442756f1c29e65f09759"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f15164f12722f1166e9672905c04592ad734fc72b94664c0a609d39974af4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f140706e105477e379e88ff39a30666f922334a8d6f2ecb81d903e0aa9133f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8923edce46cc520ceef3c69bbf9ef3b320fb57b03a117e51627859472b15f05"
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
