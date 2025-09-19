class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.5.0/apache-log4cxx-1.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.5.0/apache-log4cxx-1.5.0.tar.gz"
  sha256 "aa23f47c3164aa2cf848c2258b4b4bc372e7964d4a3ed47c2b4a4a915c5dfa37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e88d888a972a2dd6f88697f1ff225e93ba7694d3b62f74e6f173be0c364ba65"
    sha256 cellar: :any,                 arm64_sequoia: "006731ff7930748643f27134a0a8d16723cb25311497b0d450f11611dc7231dc"
    sha256 cellar: :any,                 arm64_sonoma:  "bd99190a5621c1afdbb8a9c3821bac1f5e4b15dd2ddeffdf32002bff76ff9b98"
    sha256 cellar: :any,                 arm64_ventura: "a569f566f515aa0fb58570b5c84b070fcaa1fe32b4d42570b7b733a958c5a616"
    sha256 cellar: :any,                 sonoma:        "9efcf58dfb0e1fa38d07970338c86bf383d896fc79bf968fd62ba5e3a4b374bf"
    sha256 cellar: :any,                 ventura:       "268d7e16302fad2502781adb2a27810644f793f17e21514a9ab63c17e817b5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a0d2eb67b3b2b6994055d7b2bfdddc69679643bd43ee82e9f26f68340f52680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff747cb7145c46e1ecd3e1c4cae2341ae495dc388e007f686ae6c38066321632"
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
