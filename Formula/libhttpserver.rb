class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.17.0.tar.gz"
  sha256 "5268bd0702fefe0523623a01b68d9335f40f34eeafa014e8258e5f18d924c83f"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "a5ec8663c6e9e3631ce9140de362f94545c17672fac7e0c0e3e87d00855556b4" => :mojave
    sha256 "2aae6b6d660e172880627d4c7192186a75d54f196e2f2f3900f296f3484611c1" => :high_sierra
    sha256 "654acba31d29f9ceadff90c5d3118f28dab303df5e2a809893fbbf3d3ff89f61" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"

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
    system ENV.cxx, pkgshare/"examples/hello_world.cpp",
      "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"
    pid = fork { exec "./hello_world" }
    sleep 1 # grace time for server start
    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:8080/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
