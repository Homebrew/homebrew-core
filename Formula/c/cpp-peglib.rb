class CppPeglib < Formula
  desc "Header-only PEG (Parsing Expression Grammars) library for C++"
  homepage "https://github.com/yhirose/cpp-peglib"
  url "https://github.com/yhirose/cpp-peglib/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f57aa0f14372cbb772af29e3a4549a8033ea07eb25c39949cba6178e0e2ba9cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1faee0c9bfafa9d959755e07b3b67d7cd6cdd6d90044ea73d39b00a85b139dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8a5a22292f52bfe919d39d201e60dc711526eae0022c8fc304f6007448fdc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc7e6670b936f8d5c3b876ad586274c5368087d430e8cc025d48c4984fd73bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b7c05e469149aa8d2e58804ee8077848a568e4b0fa04464b834df1da72c8e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "c792060f2dc7c50971f47fced6a91ad21ce4b2716370b310f30a152c6ee7336c"
    sha256 cellar: :any_skip_relocation, ventura:       "bcac68f110273496870596a4b0cdaac43759abc62c03332c5242c938c16d95fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dba6d295fb60a0018b6cb8618de1bcc9f0e76560c0b43d63e57f62e9a7a72c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d939b93adb7280e5a2a7632acb1341317f6a243656e51be439b5d5cb0566a0"
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
