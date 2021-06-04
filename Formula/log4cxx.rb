class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.12.0/apache-log4cxx-0.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.12.0/apache-log4cxx-0.12.0.tar.gz"
  sha256 "bd5b5009ca914c8fa7944b92ea6b4ca6fb7d146f65d526f21bf8b3c6a0520e44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5654067019235ef0ea4d7d2dda99116a5f59eb9de503d02c2831c1f54e971d88"
    sha256 cellar: :any, big_sur:       "c7c19a708049c810cea3514308e52316d25c02f8ffc1fd2eb3f80485d34bb916"
    sha256 cellar: :any, catalina:      "6cfbf907bb67c4ffb62c71e91343d894e0ead3534856933801df942f60ffc3a5"
    sha256 cellar: :any, mojave:        "1c56033e73bf61b3c5742d7b9f64f65c3d2e4223edbb30a3fef45287f3efe883"
  end

  depends_on "cmake" => :build
  depends_on "apr-util"

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
