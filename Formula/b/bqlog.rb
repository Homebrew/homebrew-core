class Bqlog < Formula
  desc "Lightweight, high-performance, cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.7.0.tar.gz"
  sha256 "0edb9fd3ba80fd286958317848cbd10795aea9c273f88c80a6fe8903afc01de5"
  license "Apache-2.0"

  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = ["-DBUILD_LIB_TYPE=both", "-DBQ_BUILD_TOOLS=ON", "-DBQ_WERROR=OFF"]
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    # A bare --parallel makes make run an unlimited number of jobs, which exhausts memory
    # on the Linux runners while the tools are compiled.
    system "cmake", "--build", "build", "--parallel", ENV.make_jobs.to_s
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~'CPP'
      #include <bq_log/bq_log.h>

      int main() {
          // create_log rejects a config without an appenders_config object, so name one.
          bq::log log = bq::log::create_log("homebrew_test",
              "appenders_config.console.type=console\n"
              "appenders_config.console.levels=[all]");
          if (!log.is_valid()) {
              return 1;
          }
          log.info("bqlog installed and linked");
          log.force_flush();
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lBqLog", "-Wl,-rpath,#{lib}",
           "-o", "test"
    system "./test"

    assert_predicate bin/"BqLog_CategoryLogGenerator", :executable?
    assert_predicate bin/"BqLog_LogDecoder", :executable?
  end
end
