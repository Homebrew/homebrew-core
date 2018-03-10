class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.1.tar.gz"
  sha256 "0da42ffcbade15b01c25683682a8f5703ec0adfe148d396057f01f1f020f3734"

  bottle do
    cellar :any
    sha256 "1262d978d45803ff690c0a6e95f0538bccb3ed87ee4febd215890a832890d12c" => :high_sierra
    sha256 "87285fa811530d34278991500e717df84afb880f2f39fce92f1ca2f2bd43d369" => :sierra
    sha256 "1a37f872ebf9eca41fd4bb8bc41a2799f32f3ead33cf9c423cf633d6485a2cc7" => :el_capitan
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
