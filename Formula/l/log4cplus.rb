class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.1.1/log4cplus-2.1.1.tar.xz"
  sha256 "a1d8e67a207f90a9dd4f82b28a1f3ac6dead5a80c2bed071277a9e865698a82b"
  license all_of: ["Apache-2.0", "BSD-2-Clause"]

  livecheck do
    url :stable
    regex(/url=.*?log4cplus-stable.*?log4cplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0c8f6c4ca96257a9deceb1dbb47c5957fb5cc977718a5424e2598563942c15ad"
    sha256 cellar: :any,                 arm64_sonoma:   "4ddfdeb6e15d5f1574b231af82c36026d1cf71febace1c1ffaf88ad8313f0395"
    sha256 cellar: :any,                 arm64_ventura:  "32be0936cf139beb9fe91fc99c94970099d052b9dd29d6f6c67e3269de3142a9"
    sha256 cellar: :any,                 arm64_monterey: "fa920ab9e524159f4b435a2c911e721568e1ec70eb0cb3532ab582883a5a3ceb"
    sha256 cellar: :any,                 sonoma:         "22a32b40fddc514edb3e1e64f7d184e420116c940c7f34a044cb3ba729955bbc"
    sha256 cellar: :any,                 ventura:        "585325a99b63b4323932e9811196b496fc3426516ef7728243773a41bdcf08c7"
    sha256 cellar: :any,                 monterey:       "6fb4f1b70586607de4741f45793c6b0a3770c77e2824818448653b0c474d4d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcece8684fc7a7537ede4ed961dbf7642d6fafe260210ece0ad155bf0621ee1b"
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
