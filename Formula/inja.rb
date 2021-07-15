class Inja < Formula
  desc "Template engine for modern C++"
  homepage "https://pantor.github.io/inja/"
  url "https://github.com/pantor/inja/archive/v3.2.0.tar.gz"
  sha256 "825e1f0076504b5aac99cc9ad8c4cbfdc33e57c06c40353f2d7b93a33caae17d"
  license "MIT"
  head "https://github.com/pantor/inja.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f5ebe5bbf698c4830d4c4aa2508053c085c2f531aa4255f3d1aa1040d5b01e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe3c6b65fe9f72935ac560e8c670b1dbe751fec0a02e9108a9898d6315ecd991"
    sha256 cellar: :any_skip_relocation, catalina:      "99ce29b9041c1723c165118582179d0541f788549d68fa269ec71ab09fdebdb8"
    sha256 cellar: :any_skip_relocation, mojave:        "0a912572fad4b9ac680aa0df36b4a0a24dd051af1534695f93922975f7e9fbc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6c70b4612cddcd313e63d7aeb42905f6adbe31aa30ed4314b113d9c0ca8a72"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json"

  def install
    system "cmake", ".", "-DBUILD_TESTING=OFF",
                         "-DBUILD_BENCHMARK=OFF",
                         "-DINJA_USE_EMBEDDED_JSON=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <inja/inja.hpp>

      int main() {
          nlohmann::json data;
          data["name"] = "world";

          inja::render_to(std::cout, "Hello {{ name }}!\\n", data);
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
           "-I#{include}", "-I#{Formula["nlohmann-json"].opt_include}"
    assert_equal "Hello world!\n", shell_output("./test")
  end
end
