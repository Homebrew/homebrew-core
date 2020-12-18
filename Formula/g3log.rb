class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.4.tar.gz"
  sha256 "2fe8815e5f5afec6b49bdfedfba1e86b8e58a5dc89fd97f4868fb7f3141aed19"
  license "Unlicense"

  bottle do
    cellar :any
    sha256 "733e3a8e675dfb858f309648bb5e7f47d9757da43d37be2042dcc0e4e1313fe3" => :big_sur
    sha256 "b819589f20ba980113593517ca9d54109a9a7cec22f756126021e2276a56bca4" => :catalina
    sha256 "1b95598a1e31c627a40d9a2b67edd10a35209dc1c426849163ee297ca05e2bc6" => :mojave
    sha256 "ac0ea62242bf04f640a7bd2cdd56a0ab585cef139748e47fe4d3ec118510dfd0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on macos: :el_capitan # needs thread-local storage

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
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
