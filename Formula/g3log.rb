class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.tar.gz"
  sha256 "b8be9ac9d888c241e1042103cd530a49baeef2853c0ab4b6dc696dad930b8784"

  bottle do
    cellar :any
    sha256 "1f0e767cd049f5e6ce968e56162314bb5facb5190918cecbe6317aeccf76bd8f" => :sierra
    sha256 "6b805ad262286f904a399909d9bcd679a3f7ffb149ce3e54b3ff58569f874236" => :el_capitan
    sha256 "e10a687eeae95b3c6b9ad2d0b1bfbfc7f9c25432e09be7cca2440a31deef34e5" => :yosemite
    sha256 "d23c1c572f56876de3d2b3fa1af8db3820c3eb958b3f9cf5f7386e530af91fe7" => :mavericks
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
