class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.5/log4cplus-2.0.5.tar.xz"
  sha256 "6046f0867ce4734f298418c7b7db0d35c27403090bb751d98e6e76aa4935f1af"

  bottle do
    cellar :any
    sha256 "1559e20cf8d6a6cbf66545ef391ab2979bbebd2cafdf4b71ab547d8daa472e01" => :catalina
    sha256 "1b671e5605cdee4defa7f6e5693ddf1e6d902710e8fecdd541429a8444df5e15" => :mojave
    sha256 "aaa4f419cf19b836d767066d505a7b4ca9addaa6392231b8f3dfd5ea2b103517" => :high_sierra
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
