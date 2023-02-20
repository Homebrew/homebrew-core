class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/2.3.tar.gz"
  sha256 "a27dc3ff0d962cc6e0b4e60890b4904e664b0df16393d27e14c878d7de09b505"
  license "Unlicense"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "becf46fe332ff6288740956a5712babec78decb132572150ebf59a1188986e12"
    sha256 cellar: :any,                 arm64_monterey: "d0f85f49ff6e852a73e42cdb3383a3545a1d62108a9734dd4524d18b30c5e084"
    sha256 cellar: :any,                 arm64_big_sur:  "34a0d768ff6c292d984ecb5816914d02293f1b8ae0fc0a23ee81af1bc6c3abc6"
    sha256 cellar: :any,                 ventura:        "84a1f8dc7cd6abf4ba19d12997fa9976fe32eb5f9b88228a19c21f37b842e3ab"
    sha256 cellar: :any,                 monterey:       "9dbf85ac511be8902890364484ef49809f6ae6c63a855ea6ddcc6bcf6dc5551a"
    sha256 cellar: :any,                 big_sur:        "6fbe06ef3fd2979960a74fbe85fa2ea92473f2509f9629768fc29bb6402c94a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e88f1a693aeaf22a7f2afe08b3342cae80a398fa84ed6dc71f805ec81ebd9cd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS.gsub(/TESTDIR/, testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
