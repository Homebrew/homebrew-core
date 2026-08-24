class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.8.0/apache-log4cxx-1.8.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.8.0/apache-log4cxx-1.8.0.tar.gz"
  sha256 "6a2e40dfa6b81a9a814ef2083d181b254f88324efff678368e5e61188a58fd3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d7ee7d9aa9ce60bb61374e38eb310beaea6390bf1ccfec1e18df144ca35d176"
    sha256 cellar: :any, arm64_sequoia: "d912c164e94ed6069b98961cc16fb6cc17e8c61ce65537852fefec4fb1bfd167"
    sha256 cellar: :any, arm64_sonoma:  "fc6942a54e1a11342b21a8b02d21f2ed3467edfd0a6a3a5429cdceee1ccb5519"
    sha256 cellar: :any, sonoma:        "434a7da60c211de91e6c14cbe7f195909d442eeb29723db277b842f421180c10"
    sha256 cellar: :any, arm64_linux:   "c1f1f810a4b3a6e6826411cf81c5e05d22fa8a0f4e23bcc9101ad7f1a235f2dc"
    sha256 cellar: :any, x86_64_linux:  "fd0de58650d630bb157fcbc21a719f615894360b2336ef06863175aa0ba051c5"
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
