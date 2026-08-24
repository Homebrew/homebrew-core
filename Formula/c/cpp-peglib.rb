class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "48145b73d080d4cad950ca6f89d5ccd3373ba4017ab488733f532a0d74afc67a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b131c3478dcb4caef29b9dc686837d8165e168d321899888f07e77388014eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27dffb52a0bb338e8230697010f53c5e9a76510bde26e7aaedb664852f642b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a589a388bcd684345b64a8325da2817c402f7fc6c87f97cc6ee9c2576df552"
    sha256 cellar: :any_skip_relocation, sonoma:        "d312e62949f03de8888de76bb027d7609b0bef6964808b6ed83f87f3345b8f84"
    sha256 cellar: :any,                 arm64_linux:   "c83d2cf505df4a8ec79b18da5774d4a7006bf00238942e117f4231111c5508af"
    sha256 cellar: :any,                 x86_64_linux:  "6b469f1026b5911dc6c9c8521494bca86b2e14bad7720ab5fe251dd980504c69"
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
