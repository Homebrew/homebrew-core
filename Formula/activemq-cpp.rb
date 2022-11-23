class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b637874d78138b4debd3b45d1bbd54d79babf16bfdfbf9acc340103208262bd"
    sha256 cellar: :any,                 arm64_monterey: "aecbae4664dd780644ff782462ea5bcdcc592917dfad01dde5370a93db641319"
    sha256 cellar: :any,                 arm64_big_sur:  "8848bb4603302677cc482a59e21f5e5651e844d3d981c75c6ab3e82257ddf234"
    sha256 cellar: :any,                 ventura:        "49bcd935f1f96ffcc79a19577e32f23d34019eea4c1436054dcf535a47d8ac97"
    sha256 cellar: :any,                 monterey:       "fc59b7bff98816254d9180614b72606f424c209a97ae1a0a6e28985af8889f6a"
    sha256 cellar: :any,                 big_sur:        "cce6f6a49cb80accb399d33826380c4220d01701b2b53f14eafde10406f835b5"
    sha256 cellar: :any,                 catalina:       "296375b0118271838d46daf6722954f6e5a8c791f08245324abd7289b4ded719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa16d5eb67f51eb3d9e648447398db44713695f5e1c5279c70f7a2229e607a9a"
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "openssl@3"

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
