class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.3.tar.gz"
  sha256 "f090380ecd6b63a3c2b2f0bdb27260de2ccb22486ef7f47cc1175b70c6e4e388"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7edddfac2c3ecf31d6a7acfd6d261019c47bf67a603dcbcdd8cbea524c632fc"
    sha256 cellar: :any,                 arm64_big_sur:  "52e6bee0d1b0f1dfea3ae69573b6a3a92c0ff42ddb41634c464fc35672e94bf4"
    sha256 cellar: :any,                 monterey:       "c5308e1c184a4a60063671305eadb56462fd60af510e437491640d9faee0f95d"
    sha256 cellar: :any,                 big_sur:        "029e18020211d4f155d07a9716303309c1b3f8d685cbd167d87f476dfe8f77a1"
    sha256 cellar: :any,                 catalina:       "9962a58f2df627f74d0c248397cc8bb8a501f0380d99bfc3a84365070ab902fc"
    sha256 cellar: :any,                 mojave:         "1667d75383b82cd2365808502c9468ca1e47aad4d6c5943b02e1aa258cad3fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403e15797cf8fd6c2caea7427e964fe4e3392eb1685d7ff9203a0d72cde26aac"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    # Change the install library directory for x86_64 arch to `lib`
    inreplace "CMakeLists.txt", "set(LIB_SUFFIX \"64\")", ""

    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cds/init.h>
      int main() {
        cds::Initialize();
        cds::threading::Manager::attachThread();
        cds::Terminate();
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lcds", "-lpthread"
    system "./test"
  end
end
