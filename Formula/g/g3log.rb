class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/refs/tags/2.6.tar.gz"
  sha256 "afd3d3d8de29825de408e1227be72f3bef8a01c2c0180c46271b4da9bb4fa509"
  license "Unlicense"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d709b89aa430846366121b385f710239c46c2f4ca6bd3dbbed07158a633b9bca"
    sha256 cellar: :any,                 arm64_sequoia: "53d72c30b9c9d193b8130c2801645c67504d5a2c12532984cbf478dd143f81ca"
    sha256 cellar: :any,                 arm64_sonoma:  "b80a5c5242decc0bd7f779bad92027c92969928c67e5b89b1c6fb15e69a1b932"
    sha256 cellar: :any,                 arm64_ventura: "c9a0603682f5e3e90ca5d878759b65898c92ad09707357f3581b0eae972412f6"
    sha256 cellar: :any,                 sonoma:        "9d4fb3f8551b036e1fe0d92c3d7c1f999c7689337981d8e39126491ef5b4bcb1"
    sha256 cellar: :any,                 ventura:       "62b18373fbcfcd6e4d096db1d501a5f49de0049dcb4d6bd8b41c54882e1dd1e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2df8ec1d0d5c4cdaeaf8568dbd20ba04216ce52f663fa03daccd046b5d66d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9c07ce3d886636fa40e90bab2e89bd0b8997b303a2470035c272f738098c7d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DADD_G3LOG_UNIT_TEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP.gsub("TESTDIR", testpath)
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
