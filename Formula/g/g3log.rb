class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/refs/tags/2.6.1.tar.gz"
  sha256 "65cb6e56e7757221fd4f3f6e97a47834cacf45288010f8fa2b192272eaa63637"
  license "Unlicense"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "465bcf7f06b31b9fae69bc916fbc73128fef05c3199e13cecadcbbede7542121"
    sha256 cellar: :any, arm64_sequoia: "caff3c0ad6f0113d5aef7734e2cfc9f511d874af93e26d1a5fac7038298740ea"
    sha256 cellar: :any, arm64_sonoma:  "4d4d929ab6d60e6582e6d166bf1b29926d49bc2df2d39bafe1e09b5b01c957a6"
    sha256 cellar: :any, sonoma:        "1fb84057c3213072be9b7b67ffa8df57ee1dc9f6b7729fddc960151612369eb2"
    sha256 cellar: :any, arm64_linux:   "bc1b18e3d9c7a32d099b28036ba2030c233c32a187133f28eac99e0363c2eaa2"
    sha256 cellar: :any, x86_64_linux:  "efaf4e5f98e3ad5403bbfe31aadc156da984faa6daa70a1fde54b26615e1e201"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DADD_G3LOG_UNIT_TEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        auto worker = g3::LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "#{testpath}");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"

    log = testpath.glob("test.g3log.*.log").first
    refute_nil log, "Expected log file"
    assert_match "\tDEBUG [test.cpp->main:8]\tHello World\n", log.read
  end
end
