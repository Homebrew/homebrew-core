class Pprint < Formula
  desc "Pretty printer for modern C++"
  homepage "https://github.com/p-ranav/pprint"
  url "https://github.com/p-ranav/pprint/archive/v0.9.1.tar.gz"
  sha256 "b9cc0d42f7be4abbb50b2e3b6a89589c5399201a3dc1fd7cfa72d412afdb2f86"

  bottle do
    cellar :any_skip_relocation
    sha256 "3106733d3d77033431baf9eac61d8cf4b293f48584858ba058d711a045512530" => :catalina
    sha256 "8d6d70f63ecea106323bdd852c1c896f32bf9895c3164680b594c0f8a30c1561" => :mojave
    sha256 "8d6d70f63ecea106323bdd852c1c896f32bf9895c3164680b594c0f8a30c1561" => :high_sierra
  end

  depends_on :macos => :high_sierra # needs C++17

  def install
    include.install "include/pprint.hpp"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cxx, "--std=c++17", "-I#{testpath}/test", "main.cpp", "-o", "tests"
      system "./tests"
    end
  end
end
