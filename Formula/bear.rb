class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.9.tar.gz"
  sha256 "bfe63d7b2847560a54060c76b4827f955b8440a8dc8ecfe88928f4e477ab5d2f"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "deef28d5dbc2df3e1f7fced4ca1077e5bc0cb910071a45e9818aa47e1b8d747e"
    sha256 big_sur:       "b0bc47161d069264bf9f3ea3bf0fe66fd0fcfb22813fda0742824a4fa013bc64"
    sha256 catalina:      "aa944713b632a387c76ed5f6d98eb512859dc6a7920a82338199000aff49628b"
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
