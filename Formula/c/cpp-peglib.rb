class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "bfb85a43191a5bc50b4a067d3f9af71d7958450f706d1a128b345265a0cdfb7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39aac971f2d4a994ba9b457fc06e293162353d4d9be913bc51a9d8829dac385c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b95d8015b936e5f5c53121108689c687c87040875eb0650777d63ced4336ccb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5654b207b0c340fca9ba4fa593e195604cf52fd3cea8cd0d1769f96e6b1dcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c6c23db3d96aa8cd42c793a1844223e867f80840367b14295715103316a6509"
    sha256 cellar: :any,                 arm64_linux:   "d51bf80c914ab90da23409d12feba25cb72b8ec02318bc017e35363c586b396a"
    sha256 cellar: :any,                 x86_64_linux:  "3cb71b55e2f613ec7d7d8b1ce8c2d36a7638dc822c7d577629749fa954a5634a"
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
