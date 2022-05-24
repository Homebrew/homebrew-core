class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4edbf0e904c82cfd6257eb1addfcfedf7e90ea1d5c20429adb92fc42ddbfff5f"
    sha256 cellar: :any,                 arm64_big_sur:  "972d1a36b67866aa3181868044bce04ec8b70cc65e5ebf3e638d5b666c6585f5"
    sha256 cellar: :any,                 monterey:       "1d30730748941d6efb2859248b5e978350cab53ac695b70df886c3a1719b5cf3"
    sha256 cellar: :any,                 big_sur:        "7fed9bcc79042fde9d0c97ac83a6fb738523772c4247c828ddc4d6b1154db8fb"
    sha256 cellar: :any,                 catalina:       "c06d4253f9496b49b63c224637a97525b13ecb834884a3548adbdafe4dde0a73"
    sha256 cellar: :any,                 mojave:         "024bf1c2c3ef8e612180b9f82c98f854235e8e371e01210c142304a762a30b3c"
    sha256 cellar: :any,                 high_sierra:    "21855925e7e9ecfe125c959c84a6bce710ca409a2a33f4f8d396f45cc52a4ab9"
    sha256 cellar: :any,                 sierra:         "c994de229e86fb7e80c846d6f2b44acba306014f334ba65550c15102214dbcb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031771786d32a435a34662e00a2802fb282ca405401d1b017e91926e1a4ccd50"
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end
