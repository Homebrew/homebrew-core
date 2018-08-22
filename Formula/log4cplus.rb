class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.2/log4cplus-2.0.2.tar.xz"
  sha256 "8ff4055be749f17f3648694bd5778bfd86d33158cceaa616a50c0299d6035b41"

  bottle do
    cellar :any
    sha256 "05ce5c61a86267690e5cf4944f4e9d55f1f568b44b4a4f0e6d0730c2c387b2c2" => :mojave
    sha256 "7f166f2c75fb63279d4e41d41c81d0f4aaea13f403662e52f032af5d551d308f" => :high_sierra
    sha256 "ce5afae2358928cb515d77e3c13288ec60c3859519253ef0d14ce792c88153a3" => :sierra
    sha256 "3a3f4952bf0064e0cd81b0e8c538ca7f49434cfb387a4f9e8441f7dbddeb6d33" => :el_capitan
  end

  needs :cxx11

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
