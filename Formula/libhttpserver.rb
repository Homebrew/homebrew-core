class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.17.5.tar.gz"
  sha256 "778fa0aec199bf8737b2d540c2563a694c18957329f9885e372f7aaafb838351"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "e0166077c271995554782fdbf558be98893e2ef64aadbcec200398b81db87f3d" => :catalina
    sha256 "086dcf919fa2afba8883e7d6c26bdd9823d8741b93ffe3864226534f71a218d9" => :mojave
    sha256 "948c65b78b36e0baf3682fb94459c33ae5283b811b836b7f4abdf27a94aa8859" => :high_sierra
    sha256 "59d96bc3f9f33c84c0700318deed666528a9ee60da8a55d45fd3450185ecfed0" => :sierra
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
