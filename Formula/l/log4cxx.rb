class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/1.4.0/apache-log4cxx-1.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/1.4.0/apache-log4cxx-1.4.0.tar.gz"
  sha256 "3d2d1f356a546c14562763aaf15fcc3fd59d4ffeb5a2f68fcb0bbd7571ed6f96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b6a997c8d90c6512afae918d7b44b86bb7d01f76d23b74ff2e78f85b37fe874"
    sha256 cellar: :any,                 arm64_sonoma:  "485bed48c83644ecb085b6484dfe3649ed67fbad384c8eb9218f1bf434743887"
    sha256 cellar: :any,                 arm64_ventura: "317df9001cb2c399dff56f52a27c5a5bc97e1b6c94916f5adae651270980b36c"
    sha256 cellar: :any,                 sonoma:        "daaa2bc0fd4e9a91892c625d9f41f6e87237d54811eb5b4afec1bd35d84a482c"
    sha256 cellar: :any,                 ventura:       "da0e6890b5b2188e034584dbeea0327f475dfa305e1e482d457c93d5708bbc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47823f5f2c6cb811c3c8b853b5989dba6277d0344adae7adde4d34dffd49b4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b594119142a0c99175b561b2048a7272e93091a039ea3f1d45671eddec0a625"
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
