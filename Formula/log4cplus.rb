class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.6/log4cplus-2.0.6.tar.xz"
  sha256 "73519a5e47c40cf375aa6cd28a703b01908b5dcd3f4cb4290db2fef237c8180c"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6b39cf87d24dccbbcd063c7d3cc21b3392c9676f2fd5c7ea7a3b2b98a294385a"
    sha256 cellar: :any, big_sur:       "3c50bcc0856327c8224074fc5f11d62e4f9033209aad12ceacd64010e1a51a80"
    sha256 cellar: :any, catalina:      "462843dd835da767dd0b422bdbe2f601db45b5fd8dbe1fcc8cdf99291592a9cd"
    sha256 cellar: :any, mojave:        "dffec0954dd25101569d672c5b07b454c80f3ee8ab4ab4cdb1d5c224395fb412"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # https://github.com/log4cplus/log4cplus/blob/65e4c3/docs/examples.md
    (testpath/"test.cpp").write <<~EOS
      #include <log4cplus/logger.h>
      #include <log4cplus/loggingmacros.h>
      #include <log4cplus/configurator.h>
      #include <log4cplus/initializer.h>

      int main()
      {
        log4cplus::Initializer initializer;
        log4cplus::BasicConfigurator config;
        config.configure();

        log4cplus::Logger logger = log4cplus::Logger::getInstance(
          LOG4CPLUS_TEXT("main"));
        LOG4CPLUS_WARN(logger, LOG4CPLUS_TEXT("Hello, World!"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}",
                    "test.cpp", "-o", "test", "-llog4cplus"
    assert_match "Hello, World!", shell_output("./test")
  end
end
