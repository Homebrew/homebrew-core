class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "81b226c4dc3e9beca5f3081c25f7c5ea4fe167f2c74b44424594bd2280a64b6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d714b45dc6c9aa4e347df1af68af3c7da56145aa05193560069ea00b41049189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cf04056d9c3e79e9eb4c45677d7a14fd6293c5d3cee95e83e20f1d33023bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dabf176d36e0aeafb4b3f89940fb58d3d1ea6bda5002acf8a3b39f007bf93333"
    sha256 cellar: :any_skip_relocation, sonoma:        "9020206c212aca51d65c3f2e4b87e8c469eed3f4a528b4a122af0163a1d377da"
    sha256 cellar: :any,                 arm64_linux:   "217aa10a4fc10098dd1295517c1ee151a0353babd58674be9892eea0a51defa8"
    sha256 cellar: :any,                 x86_64_linux:  "836d279da2765a57a731bed8c098385b8e1f64218979a07f96942efa56fdb467"
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
