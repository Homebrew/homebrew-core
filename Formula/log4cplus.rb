class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.1.0/log4cplus-2.1.0.tar.xz"
  sha256 "d84ac8b1c46645122fbf72691f8eacef68c71b587403ee833bd9a252e06d46cc"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b739d2c97ab696cab6ec893d266e41b79482b238d77c4bced0e6b0f7ccba7bea"
    sha256 cellar: :any,                 arm64_monterey: "e50c8d4a7ef6075645cb1b64949ee546b27d2a050a630ba4ab2662104248aa07"
    sha256 cellar: :any,                 arm64_big_sur:  "1dc122450d38b78c0fc1451f49f0bf524fb10e0655125aa184e573d5063d3ed9"
    sha256 cellar: :any,                 ventura:        "9b2e0339bbb57473a36590f863a2c2fc85e85d20d1bbce140060ff6a781ddaca"
    sha256 cellar: :any,                 monterey:       "271c2f01d4a4bd4c66e470a5e2dae2d46b38a42ced2c61eca1f7dfd51507d897"
    sha256 cellar: :any,                 big_sur:        "fdbb927a66ad0c9f4f2f2f06eb1978de8e591447860785e8164a0197181d8f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79fe35bf4cd51b0397d5118f37116301e23a86f53bbc1874da72f927263b1640"
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
