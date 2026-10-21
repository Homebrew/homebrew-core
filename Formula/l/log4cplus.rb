class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://github.com/log4cplus/log4cplus/wiki"
  url "https://github.com/log4cplus/log4cplus/releases/download/REL_2_2_1/log4cplus-2.2.1.tar.xz"
  sha256 "4b2801aedcdb32476a6f139a93ca01c9dac5158682516ca5a02df68c600292c6"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^REL[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4019cf235323c9599990790a890628be52b6067a7bb388841df916c7fda9beb2"
    sha256 cellar: :any, arm64_tahoe:       "477e81e58b0473787ba1f4e14c2b305e292343a72265a9ea527b857f6ec3ab02"
    sha256 cellar: :any, arm64_sequoia:     "632b145bc440e9b537e808104a71ce653e3ac095d34b6c8aca42986e5b66ae51"
    sha256 cellar: :any, arm64_linux:       "2216d022fb9c6b828d773447cb27c05d00d551f882d8627304f608d6e957c275"
    sha256 cellar: :any, x86_64_linux:      "f7baaa8ea55fa9f87b7fde6ac9ddb0e2c5ef6ffa4626f7b54e28e335de11a71e"
  end

  depends_on "pkgconf" => [:build, :test]

  def install
    ENV.cxx11
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    # https://github.com/log4cplus/log4cplus/blob/65e4c3/docs/examples.md
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    pkgconf_flags = shell_output("pkgconf --cflags --libs log4cplus").chomp.split
    system ENV.cxx, "-std=c++11", "-o", "test", "test.cpp", *pkgconf_flags
    assert_match "Hello, World!", shell_output("./test")
  end
end
