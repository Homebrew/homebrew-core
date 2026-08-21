class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.2.0/log4cplus-2.2.0.1.tar.xz"
  sha256 "6fc6b1b392921b048dcb0a71b5a1b46e9956bff710d288bdc9c4fc689f1a5f0b"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07ec8458d8fafe33456f89aa369d210251a628d10ed88178dc84ec8213921a87"
    sha256 cellar: :any, arm64_sequoia: "f40b340b18178583be8c3882541d8a58ed295c44d3356933ca4733c40e5679bd"
    sha256 cellar: :any, arm64_sonoma:  "36d985fe7364c0076b14c8101ca1ddbda683aff45db29af264186616461b3631"
    sha256 cellar: :any, sonoma:        "1da953d64d8c3095388e513870700067167f8c49a92331aba82ffc72d92426f2"
    sha256 cellar: :any, arm64_linux:   "32fbbc54d41fb1786f4fda79eeb9a4175509c7b7eb8fb1032a16ffae7074ea13"
    sha256 cellar: :any, x86_64_linux:  "a55d59db05f1d3017723b0e30c7ce625952bceff65cdd7d543b31814c8c0b50f"
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
