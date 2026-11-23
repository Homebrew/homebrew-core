class Crow < Formula
  desc "Fast and Easy to use microframework for the web"
  homepage "https://crowcpp.org"
  url "https://github.com/CrowCpp/Crow/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "4783bb3522b1de2e6300efd337ac2e234fa8f7fe9853131ee53ee47bf90cf03f"
  license "BSD-3-Clause"
  head "https://github.com/CrowCpp/Crow.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "fc31a9673a2027a14738c1670c762bb229627fbf3dfe7ef8eab6abea5641c5cf"
    sha256 cellar: :any_skip_relocation, all: "ff555a0376db9bf4a757267a399d54936323076a05e91c99a21948d3ec4819bb"
  end

  depends_on "cmake" => :build
  depends_on "asio"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCROW_BUILD_EXAMPLES=OFF", "-DCROW_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <crow.h>
      int main() {
        crow::SimpleApp app;
        CROW_ROUTE(app, "/")([](const crow::request&, crow::response&) {});
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
