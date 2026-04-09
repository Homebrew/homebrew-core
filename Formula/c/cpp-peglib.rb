class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "a20d79c32b91ed08f845b91a138c5958b3eb819d2127afcc64714ec1a6ad451b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897b6f13cca13f8de4d900bac1a85da4a287ba20ff853d74410c8db5f2b279bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79857106ad4af2b40d181378ca5e41c619f036a2ff83d3b0b0f321bbac93f6df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb27cd8e63e4d4d3363f66ff98ca2c36738424b0221af71982de63ee72a1d01"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b2c358834b2e4e2b4f125f3b3257c0164d7fc284b1d3be708032d7532ba085a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59df62df818ac8fee5d781a36aece05b9500092f7bad47a5324bc79b15ba6475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa83eab0e0b0faa7fba868fe53cb866c69fddc49e420e0d9febb3c96015eadc4"
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
