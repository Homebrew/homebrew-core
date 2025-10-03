class Hayai < Formula
  desc "C++ benchmarking framework inspired by the googletest framework"
  homepage "https://bruun.co/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e30e69b107361c132c831a2c8b2040ea51225bb9ed50675b51099435b8cd6594"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "550f637f1d8b57e9b2127a31da69c37b88928c44d67805b6126eb1b5c4119acc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "761e7c56fb8d74f8803deda44ba43cf8e483937a173f74fce264fb12a345a285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd6a2a14ff0cd666059ddf5aecbbca1679a1fd40248c981566223c308f3dd659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dccf9e4fa4cd6918a8bf6e37008b59044af49aedf965a878d35fe5200d42062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ba5eb3f260d738729a866e1951d9caf2830eacb918944da50ab0761a4b4f56"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8b827d5fa2ebb2ebf1ca3358e4014d57cfc694c3eb6da0b6ae56f1395c9b85c"
    sha256 cellar: :any_skip_relocation, ventura:        "9db2e26c1c283f4ce4875ba2c5b4639cbdfa800276f059abe407bff4098300df"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3175b383887bb7a3c8d98378c76c09fd1b1bfe9ad64e7f119df3d6054faebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ced5bfcd90e829400f4d8f92c5069d1af7b7bb913a0a3dd089f6ef41d89c86d"
    sha256 cellar: :any_skip_relocation, catalina:       "0a63325782e38d9ea125ec2948604856a2d0a95a89607bbe3eb8730ca5034009"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "595752ef429dfe91c34c27f8850eb71b88a57abf1411f7c80f9802a893b0cebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568a29e0dee5f8da2adcce268ca50150ab1f4f06e3badecf5aa2adf6fd1cb940"
  end

  deprecate! date: "2024-04-18", because: :repo_archived
  disable! date: "2025-04-22", because: :repo_archived

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <hayai/hayai.hpp>
      #include <iostream>
      int main() {
        hayai::Benchmarker::RunAllTests();
        return 0;
      }

      BENCHMARK(HomebrewTest, TestBenchmark, 1, 1)
      {
        std::cout << "Hayai works!" << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lhayai_main", "-o", "test"
    system "./test"
  end
end
