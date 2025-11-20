class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz"
  sha256 "696113659e426540625274a8b251052cc04306d8ee5c42a0c7639f39ca90c9d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "19e811fa5a096aafb80373ba53df0e7592e5e9471447173429d1201c5d2a077c"
    sha256 cellar: :any,                 arm64_sequoia:  "f8421676fbd3fc123bca6932dfe2d92f2eafaa4757a1a3d287260ea2fdb72e75"
    sha256 cellar: :any,                 arm64_sonoma:   "9dd6710dd93d90ad62742ef724afe56aab75d6686a7b67ba450945c96b64638b"
    sha256 cellar: :any,                 arm64_ventura:  "f742bcb2025862fa184116e5c431aab3da949bad797a8d4f9192549c154277a2"
    sha256 cellar: :any,                 arm64_monterey: "2e2b6848ed9ffa3265133841967798d4ffd0d7ef8c0d19ebcbdc92c828c00749"
    sha256 cellar: :any,                 arm64_big_sur:  "0aeb4d8a835632b533aae93a869073f981e236484cf6de0d909e12c72bd6fcd0"
    sha256 cellar: :any,                 sonoma:         "a8dc9b265c9f0e076dc183b600a898d6c5911597582f17ce249d39cd7cfbbb3c"
    sha256 cellar: :any,                 ventura:        "a91172e8e2ce71ce7f02272721f010923fbaa860922b516e5f5ab27ea6a7e6a7"
    sha256 cellar: :any,                 monterey:       "68f55e83feff7de8701a8f995c33468cc267b238808b195c4929a32430e1fa35"
    sha256 cellar: :any,                 big_sur:        "70a13ba2b47676203ab6affca7cecd19df2568c59df1bf6886d94bedc2d57a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f1e8877b5575ca2bfc5bbda57e8d09f236ae2be4b7c3b9247839fff34f7b1f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce5ef111899b449de8806d1ba7a63ad3f841219c7b0d8734e94a18ee67e8983"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

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
