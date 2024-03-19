class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/refs/tags/2.4.tar.gz"
  sha256 "a240673f6dda17a8d4d5768b6741534e6863e6c4d786c3678e4fe687eb115902"
  license "Unlicense"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a589b330c4106cffafba1661ea1a436733cb9f7a9d37974cdf309b1198fec252"
    sha256 cellar: :any,                 arm64_ventura:  "2d3e3a65e75427ffe6846fcd9acfdd8234ee92fb0560d90a2413d91baf65d7be"
    sha256 cellar: :any,                 arm64_monterey: "f255d677369efba5b267a8baa59c50b8c9153ad26bba7d35cf8b2f0cf107e220"
    sha256 cellar: :any,                 sonoma:         "6701a7bdd417bcbc97447829c27a36c25cf3ab88ee85788843dd6faad3a4cf3c"
    sha256 cellar: :any,                 ventura:        "919b1a44a27f6279ffa7fb0608c95635f2389b5a97f580dd986d081540662eab"
    sha256 cellar: :any,                 monterey:       "949427dd34f74189bab5b3a0625ea5512900a49d8246c1b128b8ba6fe6d0de82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc9801161cf10b1499b9f7ce1f7dc76a0b91455a7a104eb2ef3479e593fbc8a4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS.gsub("TESTDIR", testpath)
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
