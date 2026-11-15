class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/refs/tags/2.6.2.tar.gz"
  sha256 "def0e36d3e4a4382f73c3e28949cb2506ee53952c2d209dd1584f4de71880f57"
  license "Unlicense"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "49873f2179186250fbac3998335926647dc3b5e9c0a6036e4005cf3f8c14201d"
    sha256 cellar: :any, arm64_tahoe:       "f22f91e81fa7d15100763a8d0ab5cfe2cde57a32cbdc3f085a1ac300c482766e"
    sha256 cellar: :any, arm64_sequoia:     "cd4b794fa87b8020a682335a2567748005acfa6aaf2aaf35c0daa01190c9fa2c"
    sha256 cellar: :any, arm64_linux:       "904ad88c792807a2e1bb28d678d4438a1aed0a9988b9bab25dd2af5b6c815b77"
    sha256 cellar: :any, x86_64_linux:      "08e099884a633ca4e933f828cffb3d38c3c40f26e82f615a072d5cae004160ac"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
