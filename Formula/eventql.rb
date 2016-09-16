class Eventql < Formula
  desc "Database for large-scale event analytics"
  homepage "https://eventql.io"
  url "https://github.com/eventql/eventql/releases/download/v0.3.2/eventql-0.3.2.tgz"
  sha256 "d235f3e78fa5f6569fc2db94161d3e3f9cb71dc0646e341acd91814cefd23640"

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
    begin
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
end
