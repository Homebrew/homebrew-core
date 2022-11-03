class Eventql < Formula
  desc "Database for large-scale event analytics"
  homepage "https://eventql.io"
  url "https://github.com/eventql/eventql/releases/download/v0.4.1/eventql-0.4.1.tgz"
  sha256 "a61f093bc45a1f9b9b374331ab40665c0c1060a2278b2833c0b6eb6c547b4ef4"
  license "AGPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "f14adb77f2c1a4ab8ca08a55a14884e5f87058e10895bf3558e7e5b5df6329f6"
    sha256 cellar: :any, mojave:      "b6f264a76ce93195c2de6708d497c59dcb7192da13038247a33b3fd7aae5ce9a"
    sha256 cellar: :any, high_sierra: "9f0440ead195557859530cfb429c82cea72b3ad7caf3dbb6e149b5959890ad4e"
  end

  head do
    url "https://github.com/eventql/eventql.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # See https://github.com/eventql/eventql/issues/366
  # Also requires Python 2 to build older bundled SpiderMonkey
  # Original deprecation date: 2022-04-23
  disable! date: "2022-11-03", because: :unmaintained

  def install
    # SpiderMonkey sets the deployment target to 10.6, kicking in libstdc++ mode
    # which no longer has headers as of Xcode 10.
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    # the internal libzookeeper fails to build if we don't deparallelize
    # https://github.com/eventql/eventql/issues/180
    ENV.deparallelize
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pid = fork do
      exec bin/"evqld", "--standalone", "--datadir", testpath
    end
    sleep 1
    system bin/"evql", "--database", "test", "-e", "SELECT 42;"
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end
