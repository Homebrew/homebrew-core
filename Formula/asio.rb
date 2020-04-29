class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.16.1%20%28Stable%29/asio-1.16.1.tar.bz2"
  sha256 "e271db76dbbcda9835ed1c9c94deb2ba3f4589c3ebcaa71d99ac694b8d62638c"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "c2acd9065313cabbcebaf9915c28f3fc60b023fe64ade2960dfde58dbcb65bb4" => :catalina
    sha256 "ef23f2d090ea992df866715be297c3a6c9447a4a0f0aa228b025427e3975265b" => :mojave
    sha256 "717e4f0a317635e60a4b289dbc71e2c74b75c9b99880728baa4220c3d51e3f03" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
