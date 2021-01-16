class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.2.0.tar.gz"
  sha256 "3816d1a26afc04513df172678444377e0e35b9473f1f7ff85189589b831298f1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4818531d0c091179407f90ac1429ddd91ea7209f98070e5016cad16a0a093546" => :big_sur
    sha256 "bb8d8aa0a71f53a76bb5102aad8d9461f1c8e73f758a8177d2b19e4024eacefc" => :arm64_big_sur
    sha256 "51869f0e3f17a8ad20ab7de025b2a343fb8767b224d3243ab53c2b286d9e8e3d" => :catalina
    sha256 "aa73f0f63e2ae9b31967404c8d5bbaad82e6e25e955807a555f19e11f30bdd0d" => :mojave
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
