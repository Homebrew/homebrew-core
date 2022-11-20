class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.13.0/apache-log4cxx-0.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.13.0/apache-log4cxx-0.13.0.tar.gz"
  sha256 "4e5be64b6b1e6de8525f8b87635270b81f772a98902d20d7ac646fdf1ac08284"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "41118ffb5e48f82f6095694aaaa88657b49cc13cc7126b73e033b8ca7528b24a"
    sha256 cellar: :any,                 arm64_monterey: "156d458121f40aeb1ddb85c78bfb55833376c896fa9127cf2c89902ad6a01e4a"
    sha256 cellar: :any,                 arm64_big_sur:  "bd29e7d25c111e3f0467ccb20e910cf232ad28243e6cf3aad6aeb72c9a9044f2"
    sha256 cellar: :any,                 ventura:        "529ed0d5405bfc605f920ef826996a646485279b785b3f9c118b231b8d5d2c7d"
    sha256 cellar: :any,                 monterey:       "d4fc9c3b8697d0f8af74f3521e5b657d2b5f89e4440d801f84d93de559a2f35e"
    sha256 cellar: :any,                 big_sur:        "8d924e6708ac4819647c2c7ab93d3cd4fa0ee97a5debe853824fa6e01a751e42"
    sha256 cellar: :any,                 catalina:       "315a9e283ba58a053aa275bd9e0b1f7933844114c75d5503d1cd32878f9072a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a887eb24d48c9b1f0c5da04264fa8d91e20b72e1d91162e498a9ca24563ee3a"
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
