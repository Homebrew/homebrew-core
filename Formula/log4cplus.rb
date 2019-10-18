class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.4/log4cplus-2.0.4.tar.xz"
  sha256 "faf15f3651e2d0f9f9cf2c1bfcb38ec4962f22f4a671410453a27c0976da5e36"

  bottle do
    cellar :any
    sha256 "d64da534eb5d7e5b677eaa92044390c676aa59b253784ffe33507f372b55df50" => :catalina
    sha256 "8bb0963c5de1a5b6d9f08fbfa7f3a268f96784985d986ce1d016d835fdcda4d9" => :mojave
    sha256 "59a4c0794e2f300ecbe9e3dddd852af5feb5797cd3d223b810b808032aa9a605" => :high_sierra
    sha256 "3e00ce73b731f28bd3b1d86895a2b2e5c06cf3354730b638bef2d46cfc238b7b" => :sierra
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
                    "-llog4cplus", "test.cpp", "-o", "test"
    assert_match "Hello, World!", shell_output("./test")
  end
end
