class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.net/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "f090380ecd6b63a3c2b2f0bdb27260de2ccb22486ef7f47cc1175b70c6e4e388"
  license "BSL-1.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "35d45642d081770329b82ecd4fd379a6e7a9b4aa3bf0edf7a1fb81d9ce3a755b"
    sha256 cellar: :any,                 arm64_sequoia:  "03307db4af7a248e4eed5333726ee17188845f0a28403a8a716816155835d411"
    sha256 cellar: :any,                 arm64_sonoma:   "b5c6a40402166f60d1d31f28a902a6bdc80c5a878cd5fca5f7f3bca2a02edb99"
    sha256 cellar: :any,                 arm64_ventura:  "3bfa1c273ba782515935e77ada3723426fc290f26b6bf046e9a03410895c6328"
    sha256 cellar: :any,                 arm64_monterey: "e7edddfac2c3ecf31d6a7acfd6d261019c47bf67a603dcbcdd8cbea524c632fc"
    sha256 cellar: :any,                 arm64_big_sur:  "52e6bee0d1b0f1dfea3ae69573b6a3a92c0ff42ddb41634c464fc35672e94bf4"
    sha256 cellar: :any,                 sonoma:         "6357fbeba885fc7a4dd9a00ddf4e9513003776ee14501aaf30d1df3ce8ae2731"
    sha256 cellar: :any,                 ventura:        "dfabb0ee38a1df24e86ae49ae157e0995ba40379a462bffc2b1b09302301eb6a"
    sha256 cellar: :any,                 monterey:       "c5308e1c184a4a60063671305eadb56462fd60af510e437491640d9faee0f95d"
    sha256 cellar: :any,                 big_sur:        "029e18020211d4f155d07a9716303309c1b3f8d685cbd167d87f476dfe8f77a1"
    sha256 cellar: :any,                 catalina:       "9962a58f2df627f74d0c248397cc8bb8a501f0380d99bfc3a84365070ab902fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d241b0700d0649100b84c884571e4a5880fc5a04698a86a428cc0d057f6c3554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403e15797cf8fd6c2caea7427e964fe4e3392eb1685d7ff9203a0d72cde26aac"
  end

  depends_on "cmake" => :build

  def install
    # Change the install library directory for x86_64 arch to `lib`
    inreplace "CMakeLists.txt", "set(LIB_SUFFIX \"64\")", ""

    system "cmake", "-S", ".", "-B", "_build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cds/init.h>

      int main() {
        cds::Initialize();
        cds::threading::Manager::attachThread();
        cds::Terminate();
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lcds", "-lpthread"
    system "./test"
  end
end
