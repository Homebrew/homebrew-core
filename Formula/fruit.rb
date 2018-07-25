class Fruit < Formula
  desc "Dependency injection framework for C++"
  homepage "https://github.com/google/fruit/wiki"
  url "https://github.com/google/fruit/archive/v3.2.0.tar.gz"
  sha256 "78596be1c1c17d65ad3fe50c30fc817717ffb7dfc3b03d701106598a13b9ff32"

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
