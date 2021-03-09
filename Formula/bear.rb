class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.9.tar.gz"
  sha256 "bfe63d7b2847560a54060c76b4827f955b8440a8dc8ecfe88928f4e477ab5d2f"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "18abc76e49ec4d6021a0ccd7d24bf17beea6443f9946cf219f1e668cdb83c8ab"
    sha256 big_sur:       "9ce43d35accad7eff6e37d8771e7f1be9283142b26915b035a770ad3817311ff"
    sha256 catalina:      "8c036551bc9a7cedb76360a408ab07434b99e4c4f2d49932c9c2c65d927ecd39"
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
