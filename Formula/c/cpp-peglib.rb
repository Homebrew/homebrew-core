class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://yhirose.github.io/cpp-peglib/"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "15984e66941e63f1ee7f537dcc1c0f327a3f95146966bbc4fe3d424dd72903c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97378cc14facf12e1e9695b60ed9769bff221e6a6101c216b23ca36cbed1a943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5fce72d9dfc1b307c678547b1de4058b335880e01a75c7a8c4f6dbd8e75f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a094542e26aa302e8d0dbcc4f191c754a1992a6760b3a3f2e3b34af8bfa1706"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a160131deaafb8c6115913bb5b8c64c3fce3308c9c9ca2cfc822a876c856ed"
    sha256 cellar: :any,                 arm64_linux:   "50cfa7df713f701de863121add7a17bc3df89abe2e36cbe0f8aebf9d562dc189"
    sha256 cellar: :any,                 x86_64_linux:  "4d6a29a9a6c0d130f5b59aaf8bda7942674577ba66eb335b6cf4f72920e42532"
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
