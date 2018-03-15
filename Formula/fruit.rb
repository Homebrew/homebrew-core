class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.1.1.tar.gz"
  sha256 "6cbe3fa8a0ee036a618cedb95d5656c64a138addbf7f1f101acb718c708a4cc1"

  bottle do
    cellar :any
    sha256 "2add10596b4985eea2a53b903fc41004a9ecd0e981c993296da90937d3a6bcc7" => :high_sierra
    sha256 "d6829fcd71d8080f76dd21dc5d35fafa4f6c51beeb0dfff14ff4ab8821a736c0" => :sierra
    sha256 "1c2a0ee998216c8fa2cea8a9a4eb5d478efabcf0aa713480a94c365989375055" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DFRUIT_USES_BOOST=False", *std_cmake_args
    system "make", "install"
    pkgshare.install "examples/hello_world/main.cpp"
  end

  test do
    cp_r pkgshare/"main.cpp", testpath
    system ENV.cxx, "main.cpp", "-I#{include}", "-L#{lib}",
           "-std=c++11", "-lfruit", "-o", "test"
    system "./test"
  end
end
