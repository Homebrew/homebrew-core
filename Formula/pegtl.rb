class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.1.0.tar.gz"
  sha256 "591685fa4a0dc99869688a7bd01c84d750bee180dd3625a91f84e2c7b0486059"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3044879b7c3b323251009528b53b5bea68cb314f51cfec06f59ceb15f74b492b" => :big_sur
    sha256 "5fa80672bf58a5eaa91bf684ea3ef37c96b37a9b1f8246517e279a8613a0231e" => :catalina
    sha256 "854e19bfaf2383f758acb6f978ea5f8ad04e23790543facef037019832a7ce6c" => :mojave
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
