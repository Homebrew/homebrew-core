class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.2.0.tar.gz"
  sha256 "3816d1a26afc04513df172678444377e0e35b9473f1f7ff85189589b831298f1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3160182c7fdba3e18d8e1695a71cdda66f33848099639d315daf2165118203b" => :big_sur
    sha256 "6491c5852303ef963aaae07cfa64a8b7e456ef3ae38b120e6e63ffdb46e03e0f" => :arm64_big_sur
    sha256 "623df5a0987ee67f3c6f6e72a65c8b9ff26733a395c208ba0026773058a82db1" => :catalina
    sha256 "b27d99aa5cfb3b1b49a7e3a427dd45f2ca176b40f9b5e12bef4e595acf30f82b" => :mojave
  end

  depends_on "cmake" => :build

  if MacOS.version <= :mojave
    depends_on "gcc"
    fails_with :clang do
      cause "'path' is unavailable in c++ < 17: introduced in macOS 10.15"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DPEGTL_BUILD_TESTS=OFF",
                            "-DPEGTL_BUILD_EXAMPLES=OFF",
                            "-DCMAKE_CXX_STANDARD=17"
      system "make", "install"
    end
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
