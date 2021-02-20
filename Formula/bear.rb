class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.8.tar.gz"
  sha256 "663ef2fcf359e1efb20831fae3901a3edbbb906dd0bc5e62af92e353651c5cec"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "12f52a5923b8fa6861a912f0d693c7d3b20eae237069afb37a75f242f92b42e1"
    sha256 big_sur:       "a7804434d6a07751d04e290817c5ba3212c43b78e7e4c86651b3b4053878e791"
    sha256 catalina:      "0188bcf2c380ae32007526f63f5b9752d5bc491b12f11f0d44da27058ce9ac74"
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
