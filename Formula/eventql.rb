class Eventql < Formula
  desc "Database for large-scale event analytics"
  homepage "https://eventql.io"
  url "https://github.com/eventql/eventql/releases/download/v0.4.1/eventql-0.4.1.tgz"
  sha256 "a61f093bc45a1f9b9b374331ab40665c0c1060a2278b2833c0b6eb6c547b4ef4"

  bottle do
    cellar :any
    sha256 "d405964fc6f05815c58bbd92c0c3354f63d851b56cafd441ccdc4cf731baed4f" => :high_sierra
    sha256 "d1675cdb38f322f561295746f1631c89754bd99600472baf13848d6efdc04866" => :sierra
    sha256 "b4e4529266dab7d570531a569e558ca5f3d29de79e6f3a401cdfd347b59eaa68" => :el_capitan
    sha256 "de93e092a5e3f158e2a6b1d34a1016abb2d1988701c2dac3c9012d395559ce81" => :yosemite
  end

  head do
    url "https://github.com/eventql/eventql.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
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
