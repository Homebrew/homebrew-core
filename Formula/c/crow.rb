class Crow < Formula
  desc "Fast and Easy to use microframework for the web"
  homepage "https://crowcpp.org"
  url "https://github.com/CrowCpp/Crow/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c80d0b23c6a20f8aa6fe776669dc8a9fb984046891d2f70bfc0539d16998164b"
  license "BSD-3-Clause"
  head "https://github.com/CrowCpp/Crow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "591303e4c68a602b25e69d055ddd5c8ebc2e273ce056c992d7b8bdad1520d068"
  end

  depends_on "cmake" => :build
  depends_on "asio"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCROW_BUILD_EXAMPLES=OFF", "-DCROW_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <crow.h>
      int main() {
        crow::SimpleApp app;
        CROW_ROUTE(app, "/")([](const crow::request&, crow::response&) {});
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
