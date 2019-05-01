class Pprint < Formula
  desc "Pretty printer for modern C++"
  homepage "https://github.com/p-ranav/pprint"
  url "https://github.com/p-ranav/pprint/archive/v0.9.1.tar.gz"
  sha256 "b9cc0d42f7be4abbb50b2e3b6a89589c5399201a3dc1fd7cfa72d412afdb2f86"

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
