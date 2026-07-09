class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.7.0/apache-log4cxx-1.7.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.7.0/apache-log4cxx-1.7.0.tar.gz"
  sha256 "b943ff170393e4ce381ab4c4914396127bf4d44fb8bd1f0e5ef8453f3c4d364c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca7af69b56bfcf1180b4635715292f3bd9e14ee5599d33a0fd0a4a6beded079d"
    sha256 cellar: :any,                 arm64_sequoia: "a4837b88bb67a8dd807016bb5a651f4d55eac575640fbc55d005d48c2691f8d4"
    sha256 cellar: :any,                 arm64_sonoma:  "f0efff26e2e0c7b10fcdaea035287ad641a3117f71e70844111dde0160c1d08f"
    sha256 cellar: :any,                 sonoma:        "5cfb39d4ac5f7f3e22d76493b522c68daae732a54fd7a5f3ed32618282c835b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1357e5d46a023bee08eb9c9ca34fcc3e45804accdd58e3ad05f95be402e331a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51f972640d6cec94b172ffa187e83caa9b10b0ef1ef16922e6e252bc859dcf6"
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
