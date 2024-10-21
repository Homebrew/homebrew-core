class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.3.0/apache-log4cxx-1.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.3.0/apache-log4cxx-1.3.0.tar.gz"
  sha256 "801520fe8b664df2216c5194524a03efb234326f24347e778c27e4f59f913c42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc0e35478e8d145eb1d00e622ee641f1b69b5e4922b5e62cd6f40bba5e243fe3"
    sha256 cellar: :any,                 arm64_sonoma:  "9dc096c5dda72f4bb58ae947b45668d60e9afbc4a4fa897e0e165f9071f46fab"
    sha256 cellar: :any,                 arm64_ventura: "4692f58f8f661c207dc7e74198b8efe766981c11e1efd620c9401f7bc5806ef3"
    sha256 cellar: :any,                 sonoma:        "f1839934223cce206804d2342975fd31aa3d8acab39e9e5f6bac3bee36cf3511"
    sha256 cellar: :any,                 ventura:       "cbf741236036414c70cf27666fd7d88143cb762967762fc31b21f347d0c27e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17829bf537d780bb62f4dacb2a1420ce07915eea0add5f4a4d11914c18e2e354"
  end

  depends_on "cmake" => :build
  depends_on "apr"
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
