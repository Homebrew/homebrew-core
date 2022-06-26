class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.7/log4cplus-2.0.7.tar.xz"
  sha256 "8f74a0a5920ba044b24e2ebeb0f1e5e36d85d5c23ed48d9fe328882b16130db8"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b344dde7e0bfeb671a7edfc8706a98d1ac2cc8850e7030f9508846876fe42c79"
    sha256 cellar: :any,                 arm64_big_sur:  "765dbf204776bc9b7b5f69223bd0f6c8d530e78b20e66bfe52a1d3a98f6304df"
    sha256 cellar: :any,                 monterey:       "095da8330cf32913b779971ed13206f34f312c09924c6e4a35d3121260a29a52"
    sha256 cellar: :any,                 big_sur:        "020f5bb424ba5b13c36a031d0faffbf0bae4132aca32dc8fbb8020e30ac82260"
    sha256 cellar: :any,                 catalina:       "0ca8fc813a82137c28138a19d602344756233447b8b0789880f911e7e597b9e7"
    sha256 cellar: :any,                 mojave:         "b1bd74384498b0fa7617a0fbd70e56af32d2c84d7c3552cae86cbdca52dcf323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65982c47478a5a2d7fe345429ddbe7a076734948425a42a988749ab4d627e003"
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
