class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.5.tar.gz"
  sha256 "6ae48cc0081b24270ec3398e71b68f77b45e93be15ff4d44c00259c9cdc5cc5a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d325eaadac7646b1f637bcd8277bc4bd8a29b57da84a40541064b8008b1fc21"
    sha256 cellar: :any,                 arm64_sequoia: "92bbf1c1329d4f149a42f2fb278e8ae25776b1f7cdddda05fb4e9194646606ef"
    sha256 cellar: :any,                 arm64_sonoma:  "f58dddace010b021f7d682fcc0caf41b2adc26ea90cfe7d554393fe5253d10cc"
    sha256 cellar: :any,                 sonoma:        "f0545cabeb7cc544fd96bb3d57ae359732c2038161522dcac37842bdfd1907b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a36fad9790208b1777e87b90443103d3045b77c52582e98d729dc4742c9f294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418404c1a5bc5d97e4fed6011d80a9d23af0f882c832ff6d8318db72b4b74fb7"
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
