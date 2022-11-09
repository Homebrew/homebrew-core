class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/2.0.1.tar.gz"
  sha256 "b5db9008aa66c3130dc13ab83766368f2491ea87931de7e30f4db416b4964c00"
  license "Unlicense"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad4af58dea1fbcc525f5fed66daa7baadf7df43a4bf11fd08fce23e6213d58e0"
    sha256 cellar: :any,                 arm64_big_sur:  "e6a54f2b1e8af866bb3d4e8208213d214f85b83cef3d729acb52207bbdf67f56"
    sha256 cellar: :any,                 monterey:       "aa72dea515d8a3d60db36d072ff2069489a18bcade85932bbc9c3be50e8f196c"
    sha256 cellar: :any,                 big_sur:        "66a1c4830ff6be880401a638a15480bcabf25e6cd56b0e37f3e76785cb8b246a"
    sha256 cellar: :any,                 catalina:       "cafa65bf65890e7ad78abbfbf0c58c2ab22f595e8d193c601655bcb7f9ac3636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca24da4e23d767a8da2e58825f73ed0d9bbe5bc695d6480687035a611c3b7e1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
