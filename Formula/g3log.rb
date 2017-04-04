class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.tar.gz"
  sha256 "b8be9ac9d888c241e1042103cd530a49baeef2853c0ab4b6dc696dad930b8784"

  bottle do
    cellar :any
    sha256 "87285fa811530d34278991500e717df84afb880f2f39fce92f1ca2f2bd43d369" => :sierra
    sha256 "1a37f872ebf9eca41fd4bb8bc41a2799f32f3ead33cf9c423cf633d6485a2cc7" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # No install target yet: https://github.com/KjellKod/g3log/issues/49
    include.install "src/g3log"
    lib.install "libg3logger.a", "libg3logger.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libg3logger.dylib", "#{lib}/libg3logger.dylib")
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent.gsub(/TESTDIR/, testpath)
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
