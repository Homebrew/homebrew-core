class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.1.0/apache-log4cxx-1.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.1.0/apache-log4cxx-1.1.0.tar.gz"
  sha256 "1fc7d82697534184bc0f757348d969d24852b948f63d6b17283fd1ee29c2c28a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5e8608447ef140e30beb4d3af98ead428159fa2cf3a561e88e47249de504131"
    sha256 cellar: :any,                 arm64_monterey: "7e4b418f5e96883128b3ff409974f63179ec2e4b05f8c8f53aed25a836b051bf"
    sha256 cellar: :any,                 arm64_big_sur:  "84b64c6a7f245af8bfe68ebe0162b69398657a7f9768a0b6221cc51706f65811"
    sha256 cellar: :any,                 ventura:        "890ffbebd63b81412b019d66a07b6ac2595e6a3bf7d0a5dd19deb1e129f99fe4"
    sha256 cellar: :any,                 monterey:       "8c30ba98d371b21078c04b2eddf1523fa2750cc11c81714565d830c727eacfe4"
    sha256 cellar: :any,                 big_sur:        "386b8149bb19eeec6524525634c06d3179d63b9a77fee090ff5f65dd11009fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c40e3a445d05d3d18b3a6b94b331739bd0225f8599cb364d3faa54bdaf21ef56"
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
