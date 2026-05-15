class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.6.tar.gz"
  sha256 "a036bc6bd6044479e6c456de7edd042b060ea5c843e47beb75f59baea9b20e3a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "962a73cba13a5c907b21822beffe517e8441fd98e3c6fe7ac8bdc1ba9faf4d1d"
    sha256 cellar: :any,                 arm64_sequoia: "343d766065eb68e22076aa39441d6b3c95291e55431b29ca247cc7f08d2e28ac"
    sha256 cellar: :any,                 arm64_sonoma:  "ed36ef6c80e0a82ca896797d05816b2bf2e9377d5fb152c213da0618bae5482b"
    sha256 cellar: :any,                 sonoma:        "35166d43fb793e78fd14f02456dc6ef3e7e6cbab437047bb09aba4ce14c65362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32e5f90f73eb1fdffe63767ab7c9ba44480c05c6e0d60841ca9a6be37097d3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30903c8dc26bb4b6c98b086e72a847454433df63161822a868e1fac93c033f95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.cxx11
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"log4cpp.cpp").write <<~CPP
      #include <log4cpp/Category.hh>
      #include <log4cpp/PropertyConfigurator.hh>
      #include <log4cpp/OstreamAppender.hh>
      #include <log4cpp/Priority.hh>
      #include <log4cpp/BasicLayout.hh>
      #include <iostream>
      #include <memory>

      int main(int argc, char* argv[]) {
        log4cpp::OstreamAppender* osAppender = new log4cpp::OstreamAppender("osAppender", &std::cout);
        osAppender->setLayout(new log4cpp::BasicLayout());

        log4cpp::Category& root = log4cpp::Category::getRoot();
        root.addAppender(osAppender);
        root.setPriority(log4cpp::Priority::INFO);

        root.info("This is an informational log message");

        // Clean up
        root.removeAllAppenders();
        log4cpp::Category::shutdown();

        return 0;
      }
    CPP
    system ENV.cxx, "log4cpp.cpp", "-L#{lib}", "-llog4cpp", "-o", "log4cpp"
    system "./log4cpp"
  end
end
