class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.12.1/apache-log4cxx-0.12.1.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.12.1/apache-log4cxx-0.12.1.tar.gz"
  sha256 "7bea5cb477f0e31c838f0e1f4f498cc3b30c2eae74703ddda923e7e8c2268d22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "92098a38ef9a8734f011e3c5fa207fbd8ec28c4523c40e64d9aabd17f40fa46c"
    sha256 cellar: :any,                 arm64_big_sur:  "56c60d9be7f933a782852a55dd1feb6975a0063a73b14670d27a6c375ece7e49"
    sha256 cellar: :any,                 monterey:       "bf15c6f2d2267be76d58096db985e46c8a3af6b3c3e77b1c2fd1750661b27cf4"
    sha256 cellar: :any,                 big_sur:        "6d1b6f87ea1ffcc38069798e5150ad6523e7d64d2682b1c4afc2e4bd1c5e9294"
    sha256 cellar: :any,                 catalina:       "8f33426b24d1d711a72ce4ee1328a5c73607d5f1755c8055361aa9f74dbbebae"
    sha256 cellar: :any,                 mojave:         "14367506f0070f9142b47ca2de95101440ff0b9a6a1ea00dc6095d338c0f2b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e640dce6a616b1e0f083069b51f77da795916fde0e17da4a9d1a5a16bbb652df"
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
