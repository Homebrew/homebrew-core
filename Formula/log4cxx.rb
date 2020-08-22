class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.11.0/apache-log4cxx-0.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.11.0/apache-log4cxx-0.11.0.tar.gz"
  sha256 "c316705ee3c4e5b919d3561d5f305162d21687aa6ae1f31f02f6cdadc958b393"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "61d3bf62743bd2e2d6537f0f7d795eab7098d2a3917b526832f2eeebdbbb5171" => :catalina
    sha256 "3394ba006562401352b3ba42857f9e8ccd3f84d23e4ce7c22041c0bd82d1cdda" => :mojave
    sha256 "0d29b911db2c77048046e048589fcf6739b72f25494145f8d0650d81b67a36f1" => :high_sierra
    sha256 "0e1c8e304f87bdb864f14e7b158e2f9e82ab4300a0ea144a8abaf9c8d5bc2976" => :sierra
    sha256 "16eb54dca4f5d772a23d55d9599947f93a8c6003df5d6a4ad468b99daeda9153" => :el_capitan
    sha256 "b96afe3f4e4b63017d2061028ed8792c4190996b1e008d8c87c3f52dba660ec5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "apr-util"

  def install
    ENV.O2 # Using -Os causes build failures on Snow Leopard.

    # Fixes build error with clang, old libtool scripts. cf. #12127
    # Reported upstream here: https://issues.apache.org/jira/browse/LOGCXX-396
    # Remove at: unknown, waiting for developer comments.
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Docs won't install on macOS
                          "--disable-doxygen",
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--with-apr-util=#{Formula["apr-util"].opt_bin}"
    system "make", "install"
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
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-llog4cxx"
    assert_match /ERROR.*Foo/, shell_output("./test", 1)
  end
end
