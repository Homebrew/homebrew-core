class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.11.tar.gz"
  sha256 "3f426b5b22cab1ed6146aaba1dd612cd387b7298915ca58a72386bc8c1c9d9da"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "4eefc04b49ba8fb2108ca9fce093919852f971f207bcc98ee572ecc3ef031841"
    sha256 big_sur:       "08415314158803ba6373e911fb9efadb58543774d5c5c231b9c9446371c2696b"
    sha256 catalina:      "bb25ee188cfbc10ae75dbf265eb84cec615645b4e328110bc24055ae5a89e26c"
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

  uses_from_macos "llvm" => :test

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

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
