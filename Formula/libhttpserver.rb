class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.18.1.tar.gz"
  sha256 "c830cb40b448a44cfc9000713aefff15d4ab1f6ebd6b47280a3cb64cb020f326"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "95189595f6b252fb49de7d388416fca1c7107347d2e72401cc2f59dff9bb61ab" => :catalina
    sha256 "a7ba4e925c9e5597721523f528f16e76c427a54f3986ffa213f3c66c62e60a83" => :mojave
    sha256 "190a74ca1999a1e42877971ee39b1f79f2ef5742ced8db46c2115d4fa5729d9c" => :high_sierra
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
