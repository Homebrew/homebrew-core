class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.3.1/apache-log4cxx-1.3.1.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.3.1/apache-log4cxx-1.3.1.tar.gz"
  sha256 "2c4073c0613af7f59a75d8f26365dc6f5b07a22b9636ee5c5f7bfa9771a2c1d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "741f844e58834a46c4d6719ca5b66c3c60d35fda0c7eeab712e15b144242f219"
    sha256 cellar: :any,                 arm64_sonoma:  "cace90c799d3bec01573bd0c1a49d11e8a5dffb0b1ef232838e861a2e7c388e2"
    sha256 cellar: :any,                 arm64_ventura: "7fc87dce1c0a22e50815625e6a3f848375a785e983035400473ae9efb7c0d56e"
    sha256 cellar: :any,                 sonoma:        "923ec4caedf69f571f0da892dd70fa27c8549c880a8bd6af3032e440f8d97973"
    sha256 cellar: :any,                 ventura:       "0d0c65175dda2f77ac9c13549363e58dba57f2c76fc1cbdd1a6fb9fd1c1b551c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e715a250c94d44397172a4a654d4b9c7c183f3b34c95af34872d3cf0acecc9b6"
  end

  depends_on "cmake" => :build
  depends_on "apr"
  depends_on "apr-util"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <log4cxx/logger.h>
      #include <log4cxx/propertyconfigurator.h>
      int main() {
        log4cxx::PropertyConfigurator::configure("log4cxx.config");

        log4cxx::LoggerPtr log = log4cxx::Logger::getLogger("Test");
        log->setLevel(log4cxx::Level::getInfo());
        LOG4CXX_ERROR(log, "Foo");

        return 1;
      }
    CPP

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
