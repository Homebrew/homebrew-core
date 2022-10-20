class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.8/log4cplus-2.0.8.tar.xz"
  sha256 "f5949e713cf8635fc554384ab99b04716e3430f28eed6dd7d71ad03d959b91a0"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c462b9d31dce4812a51fe1a620d423bacc424d12abfba3b9e161a3debda65b6"
    sha256 cellar: :any,                 arm64_big_sur:  "fe85d95a5749af4c54332c4f799a121b8d15a11f949e96abbb22a8287a8c4c2c"
    sha256 cellar: :any,                 monterey:       "affad148e3fc8a11f5c3cfcca7aaa0b78a6fb0c1c1a23c43107b12af159274bc"
    sha256 cellar: :any,                 big_sur:        "7130b433ddac37a7c5f7621b7e715944286432464d484bb1002863d1551c4066"
    sha256 cellar: :any,                 catalina:       "59a7948863b88c2c47a138fc2a436aebbaae49ad4d674e0f5ce6489ad0ff9c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644160ffb7361c99bd2b95674492f1545ffdc1ec36548f54249da82a6db18d3f"
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
