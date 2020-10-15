class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.3.tar.gz"
  sha256 "d8cae14e1508490145d710f10178b2da9b86ce03fb2428a684fff35576fe5d5c"
  license "Unlicense"

  bottle do
    cellar :any
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-L#{lib}", "-lg3logger", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
