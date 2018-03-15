class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.1.tar.gz"
  sha256 "0da42ffcbade15b01c25683682a8f5703ec0adfe148d396057f01f1f020f3734"

  bottle do
    cellar :any
    sha256 "2a6c66a3a9933dd0918f81fa1bbef94096fce35d110415def54f89a408955d5c" => :high_sierra
    sha256 "75c11ba63925121e07686aa523a7b2a53d562cb11f65e35cdc1d5e84dbd5d4fa" => :sierra
    sha256 "aef7cad94b8ba72ec2e50d1dbc8827d2dabbc2594a9cc17300235055f81f76a7" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs thread-local storage
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lg3logger", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
