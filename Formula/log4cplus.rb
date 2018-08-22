class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.2/log4cplus-2.0.2.tar.xz"
  sha256 "8ff4055be749f17f3648694bd5778bfd86d33158cceaa616a50c0299d6035b41"

  bottle do
    cellar :any
    sha256 "f2a45f8cc305f0e360656e014e66919eb6c97c2902a108a309df5c9b397ea532" => :mojave
    sha256 "eacdee3aa723c125f98c7c5d548b918711dcdbc495694607e72b3b497310f3c1" => :high_sierra
    sha256 "4508ad12bb420fbfc24554c874a2d232353984aeba4c44f107f0173e54bbc0ec" => :sierra
    sha256 "91cf1b0b9bd6daae6bd30c26ae7eeecc589e0ca236c07076737de1e41285ade9" => :el_capitan
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
