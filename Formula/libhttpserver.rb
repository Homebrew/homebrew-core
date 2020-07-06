class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.18.1.tar.gz"
  sha256 "c830cb40b448a44cfc9000713aefff15d4ab1f6ebd6b47280a3cb64cb020f326"
  license "LGPL-2.1"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "e7f063d3efcf580237ee3a414102aabb09604f9f50956f3193ed78d2cdc700d7" => :catalina
    sha256 "61520d55052d75ea8761d89f892c6b97ecb4811236bbdb748630cca00130b441" => :mojave
    sha256 "8a48967a0dc9715133455dd6ca548ee16652d451c5cba71c85df9b1ce904f442" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/hello_world.cpp", testpath
    inreplace "hello_world.cpp", "create_webserver(8080)",
                                 "create_webserver(#{port})"

    system ENV.cxx, "hello_world.cpp",
      "-std=c++11", "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    pid = fork { exec "./hello_world" }

    sleep 1 # grace time for server start

    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
