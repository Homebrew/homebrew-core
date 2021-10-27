class Pprint < Formula
  desc "Pretty printer for modern C++"
  homepage "https://github.com/p-ranav/pprint"
  url "https://github.com/p-ranav/pprint/archive/v0.9.1.tar.gz"
  sha256 "b9cc0d42f7be4abbb50b2e3b6a89589c5399201a3dc1fd7cfa72d412afdb2f86"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c299956c83c6f1af4511db5e69cad0e678779646c40cebdd03176368510d2c58"
  end

  depends_on "catch2" => :test
  depends_on macos: :high_sierra # needs C++17

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    include.install "include/pprint.hpp"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      rm "catch.hpp" # The bundled Catch2 is too old to work on Apple Silicon
      system ENV.cxx, "main.cpp", "--std=c++17",
             "-I#{testpath}/test", "-I#{Formula["catch2"].opt_include}/catch2",
             "-o", "tests"
      system "./tests"
    end
  end
end
