class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.2.0/apache-log4cxx-1.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.2.0/apache-log4cxx-1.2.0.tar.gz"
  sha256 "09f4748aa5675ef5c0770bedbf5e00488668933c5a935a43ac5b85be2436c48a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8c5489d45bf2b3bc855f59dbacbd6399b3d9f92ac00a1d11e51617bd48eefe77"
    sha256 cellar: :any,                 arm64_sonoma:   "ae968c162e73526143bcaeea0522ee360a8e2adb760907deb985e0f403eeaf4a"
    sha256 cellar: :any,                 arm64_ventura:  "97fb128001e637e57e029e2b2bf49de3fe7a066948c7b07e6efe1ac632a04f2c"
    sha256 cellar: :any,                 arm64_monterey: "12f426219bc428535331856f114e9cc62ee7c6e27562a19bd99f687d1a9bea92"
    sha256 cellar: :any,                 sonoma:         "4ccefef8d95df7a5de25e9cdc12a35c2294343f7e25946fd595d3fa109a97af1"
    sha256 cellar: :any,                 ventura:        "07223ca4687861da6e1dfefde93c4cca205af8a8c44abba7e4171889c77cc051"
    sha256 cellar: :any,                 monterey:       "2b81e6a1ce0e9f4d7be75fa8e32bd3d0f8919a50cadc15c5887db60995b0b982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef721c73d011ef0cba1683287e67e61a09b7f97e75be0328a748994bbdef7379"
  end

  depends_on "cmake" => :build
  depends_on "apr-util"

  fails_with gcc: "5" # needs C++17 or Boost

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
