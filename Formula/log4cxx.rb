class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.0.0/apache-log4cxx-1.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.0.0/apache-log4cxx-1.0.0.tar.gz"
  sha256 "6df9f1f682650de6045309473d5b2fe1f798a03ceb36a74a5b21f5520962d32f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d0f33b32809f8e031fb6205652936a3461615e6581d550bc2564d036a211478"
    sha256 cellar: :any,                 arm64_monterey: "00f20ed7f3f8899e1c8bfde63fc5a6d669a8d74de675272d9e7a39db5acebac1"
    sha256 cellar: :any,                 arm64_big_sur:  "191c762c51bc54d2d40ed443112ad031bb06c8f5c93274d3d06372896eeef821"
    sha256 cellar: :any,                 ventura:        "247d1bee0654a1c6e768109e87f8707fd4c6cf14fa4177fac36f3c0bd90ac027"
    sha256 cellar: :any,                 monterey:       "98a0592d6d08dbaed5508b24d6f334718b4dd8c368b2c76dc27a75c57f08d569"
    sha256 cellar: :any,                 big_sur:        "cd86acc7a5d5c6668d9f9c5dfbc44ac4a26348148f3daeb96d6bf113615d3019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe4c29052b04fd9c3e4382e5acd5b9cccc910ad3b35826ece37a4420725b15ec"
  end

  depends_on "cmake" => :build
  depends_on "apr-util"

  fails_with gcc: "5" # needs C++17 or Boost

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <log4cxx/logger.h>
      #include <log4cxx/propertyconfigurator.h>
      int main() {
        log4cxx::PropertyConfigurator::configure("log4cxx.config");

        log4cxx::LoggerPtr log = log4cxx::Logger::getLogger("Test");
        log->setLevel(log4cxx::Level::getInfo());
        LOG4CXX_ERROR(log, "Foo");

        return 1;
      }
    EOS
    (testpath/"log4cxx.config").write <<~EOS
      log4j.rootLogger=debug, stdout, R

      log4j.appender.stdout=org.apache.log4j.ConsoleAppender
      log4j.appender.stdout.layout=org.apache.log4j.PatternLayout

      # Pattern to output the caller's file name and line number.
      log4j.appender.stdout.layout.ConversionPattern=%5p [%t] (%F:%L) - %m%n

      log4j.appender.R=org.apache.log4j.RollingFileAppender
      log4j.appender.R.File=example.log

      log4j.appender.R.MaxFileSize=100KB
      # Keep one backup file
      log4j.appender.R.MaxBackupIndex=1

      log4j.appender.R.layout=org.apache.log4j.PatternLayout
      log4j.appender.R.layout.ConversionPattern=%p %t %c - %m%n
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-llog4cxx"
    assert_match(/ERROR.*Foo/, shell_output("./test", 1))
  end
end
