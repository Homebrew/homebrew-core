class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.6.1/apache-log4cxx-1.6.1.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.6.1/apache-log4cxx-1.6.1.tar.gz"
  sha256 "187c85836f5b2f27fb1e8d77c7f1f2939725f1f6498b742b0dd569ba30965fd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e7d305b96aefd5a83ce663a838bef388b85a9cc3a60bee69dd7b53661c2088b"
    sha256 cellar: :any,                 arm64_sequoia: "b5b9d5ecac30748a893f94b00ffb870f3a1b273fa6dc4c20a0e36bd47dde146e"
    sha256 cellar: :any,                 arm64_sonoma:  "1a2b8966bbbc569fa3dbb27f4bbf0ccd7fb30be111d03a88f60a2679a6177dfb"
    sha256 cellar: :any,                 sonoma:        "ee2229f704625ee23db06ca15a2946250470c20e99091a924f00088a62a4c309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9870e1e954d13a41db98603291cfdc101303fbe79e343b08d3019c4663b7cd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f226f5049d3c0b2dd1ae642bc2ac7c1e39cd89583f4124b5922619c6efabd440"
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
