class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.13.0/apache-log4cxx-0.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.13.0/apache-log4cxx-0.13.0.tar.gz"
  sha256 "4e5be64b6b1e6de8525f8b87635270b81f772a98902d20d7ac646fdf1ac08284"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "47607aa9485c1167eb9238bba3843a61ac4c08237e12f5fe381419917bfa9c10"
    sha256 cellar: :any,                 arm64_big_sur:  "822486177f347c4eb3260e8a634d28aeb0760ae9104a8d68f1590584b165c7e7"
    sha256 cellar: :any,                 monterey:       "6f0afc83f3bb946675995dc4bb7d39ec7e18e6fd5eca07beeb81064811764619"
    sha256 cellar: :any,                 big_sur:        "7eb48735b6ba092b54d19fba4d9337d8370836d87b2a8bcaa22f1a1e85b0d203"
    sha256 cellar: :any,                 catalina:       "622e2411659ddefe72488305f678c05aabbcf9bba614be4ad258f4c3da5b3356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52103cd2eb242d06e699db8919340534545fef4688b01aec1a4d70b52d7fce66"
  end

  depends_on "cmake" => :build
  depends_on "apr-util"

  on_linux do
    depends_on "gcc"
  end

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
