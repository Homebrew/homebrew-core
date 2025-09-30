class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.1.2/log4cplus-2.1.2.tar.xz"
  sha256 "fbdabb4ef734fe1cc62169b23f0b480cc39127ac7b09b810a9c1229490d67e9e"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2a1d0840621edc53d144eeca4f745ba6192061d457e8e0a60e6d28b23ed27e7"
    sha256 cellar: :any,                 arm64_sequoia: "c2330f21e0b3c6f379e155d8270f758067c67d5086bad74350dd6841114f70ac"
    sha256 cellar: :any,                 arm64_sonoma:  "8035d145371eff042f792dc7a2627c9b67a3f20530fb2f66e07e7b4bd25eeb93"
    sha256 cellar: :any,                 arm64_ventura: "b60bac8e9aaf34f6b81055d7ebc3578462e1e144855e1e3d416e54fa87346fab"
    sha256 cellar: :any,                 sonoma:        "b3cbcf75711ecb77bbf59942f30e8e6767105753b5363cc8cd8ca5d13201314b"
    sha256 cellar: :any,                 ventura:       "7c62fc3ea51cc81fae1f97f5649898fdb567667b67d99fd419347e237b636fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d789ed4a5d65789a09539bb155c14708acd9f7037318c43233933690d10cf474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038cc5359e99cc5e80a899304e02f22c54156539c5b3db4e03516982ebdb3c12"
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
