class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/2.8.3.tar.gz"
  sha256 "88b8e4ded6ea1f3f2223cc3e37072e2db1e123b90d36c309816341ae9d966723"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :catalina
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :mojave
    sha256 "10ad60dbc5a6c4054579b2e7529dfb053395cfd2c9bc5ddb5c2bf6b939b8f9cd" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DPEGTL_BUILD_TESTS=OFF",
                            "-DPEGTL_BUILD_EXAMPLES=OFF"
      system "make", "install"
    end
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++11", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
