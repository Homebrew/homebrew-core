class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.3.2.tar.gz"
  sha256 "0ed1983654fdd8268e051274904128709c3d9df8234acf7916e9015199b0b247"

  bottle do
    cellar :any
    sha256 "6430e3761f6d80cbc9a088079adc7ade9a32c2924721bd005b4d28bf8d68ef46" => :catalina
    sha256 "ff0722f39f2bf0496565930e9a6fca1cb053c5e120d0628bcdc8ad336c2c9f54" => :mojave
    sha256 "59c77b06d62ea06a4aa96ce6ecf1903a415d32248631cadc2c1787e291f006fc" => :high_sierra
    sha256 "be3b9045a3cc0e011db0e9d9bd7b8feda8080a0fb591edb33a846d990395f4f6" => :sierra
    sha256 "4cd2f01ea225e95a348d1a514cf14f2c51eb47b1ef2f86c8d3e7c8218ba0eb31" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

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
