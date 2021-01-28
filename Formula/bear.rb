class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.8.tar.gz"
  sha256 "663ef2fcf359e1efb20831fae3901a3edbbb906dd0bc5e62af92e353651c5cec"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 "b2cb1d2a69961eb48dfe78b1a904e5e062121a36bc833b32750d5d2e9e4b1303" => :big_sur
    sha256 "3400e1dd8f85207ca25fa696bf9888e0ed1474246713ded9d1263407b72e5465" => :arm64_big_sur
    sha256 "97abc44083299426ade4bf4fa96cf9bd91741214beb7ffb1fa3c03739ca9a123" => :catalina
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on macos: :catalina
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "spdlog"
  depends_on "sqlite"

  def install
    args = std_cmake_args + %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
    end

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
