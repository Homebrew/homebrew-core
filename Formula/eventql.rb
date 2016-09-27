class Eventql < Formula
  desc "Database for large-scale event analytics"
  homepage "https://eventql.io"
  url "https://github.com/eventql/eventql/releases/download/v0.3.2/eventql-0.3.2.tgz"
  sha256 "d235f3e78fa5f6569fc2db94161d3e3f9cb71dc0646e341acd91814cefd23640"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb5a697a9e91c2523e24d8d81e842d26001992aa5d4d9867dac7ec4ebe6b81a0" => :sierra
    sha256 "7d128462969fc4e431c6a486fca5f397fc15c46e657a622d042c0bf531efba82" => :el_capitan
    sha256 "482a655e17d0b905d0101d2716f52266e1ec8bb6a4814f30a576431fa2d179e4" => :yosemite
    sha256 "92adde0e08a4bc68c90f1e93f13ee7afc7bc1c7b69f2187610545bcbcb76abd8" => :mavericks
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
