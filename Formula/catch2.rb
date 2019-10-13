class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.10.0.tar.gz"
  sha256 "a3beaa8ba6238c189e1f81238ab38e585836af13204a7099e22eff6c25b98558"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d89f944fbfddf8d64a194f3e7212e66f1a0079837ba382eb37683d3b9e7eeb" => :mojave
    sha256 "b9d89f944fbfddf8d64a194f3e7212e66f1a0079837ba382eb37683d3b9e7eeb" => :high_sierra
    sha256 "a629d46127d91f45b4d27144888ae6a01b9d41653278144547e583bbd8facac7" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
