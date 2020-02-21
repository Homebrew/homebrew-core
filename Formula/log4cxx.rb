class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz"
  sha256 "0de0396220a9566a580166e66b39674cb40efd2176f52ad2c65486c99c920c8c"
  revision 1

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

  # Incorporated upstream, remove on next version update
  # https://issues.apache.org/jira/browse/LOGCXX-400 (r1414037)
  # https://issues.apache.org/jira/browse/LOGCXX-404 (r1414037)
  patch :p0 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/be8b4e610a1e21b34aaaf8fb4151362dcfb782ff/LOGCXX-400,LOGCXX-404---r1414037.patch"
    sha256 "822c24f4eebd970aa284672eec2f71c6f8e192a85d78edb15a232c15011a52d4"
  end

  # https://issues.apache.org/jira/browse/LOGCXX-417 (r1556413)
  patch :p0 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/4188731bd771a961a91fcfbe561f3999b555b9c3/LOG4CXX-417---r1556413.patch"
    sha256 "eca194ec349b4925d0ad53d2b67c18b6a1aa7a979e7bd8729cfd1ed1ef4994c7"
  end

  # https://issues.apache.org/jira/browse/LOGCXX-400 (reported)
  patch :p1 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/f33998566cccf91fb84133e101f5a92a14b31aed/LOGCXX-404---domtestcase.cpp.patch"
    sha256 "3eaf321e1df8e8e4a0a507a96646727180e7e721b2c42af22a5d40962d3dbecc"
  end

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
