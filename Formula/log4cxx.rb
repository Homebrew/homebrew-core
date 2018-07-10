class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://github.com/kekkokk/logging-log4cxx/releases/download/0.10.0_with_fixes/log4cxx_latest_stable.tar.gz"
  sha256 "d0e57ecaa61980f450677783736a6d71f549ef0c75adfd209e87fb0db6119f8c"
  revision 2

  bottle do
    cellar :any
    sha256 "0d29b911db2c77048046e048589fcf6739b72f25494145f8d0650d81b67a36f1" => :high_sierra
    sha256 "0e1c8e304f87bdb864f14e7b158e2f9e82ab4300a0ea144a8abaf9c8d5bc2976" => :sierra
    sha256 "16eb54dca4f5d772a23d55d9599947f93a8c6003df5d6a4ad468b99daeda9153" => :el_capitan
    sha256 "b96afe3f4e4b63017d2061028ed8792c4190996b1e008d8c87c3f52dba660ec5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "apr-util"

  # Fix to build LOGCXX-225
  patch :DATA

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

__END__
diff --git a/src/main/include/log4cxx/helpers/simpledateformat.h b/src/main/include/log4cxx/helpers/simpledateformat.h
index 9c27f68..39da173 100644
--- a/src/main/include/log4cxx/helpers/simpledateformat.h
+++ b/src/main/include/log4cxx/helpers/simpledateformat.h
@@ -27,10 +27,9 @@

 #include <log4cxx/helpers/dateformat.h>
 #include <vector>
+#include <locale>
 #include <time.h>

-namespace std { class locale; }
-
 namespace log4cxx
 {
         namespace helpers
