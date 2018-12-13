class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.15.0.tar.gz"
  sha256 "d32a8000923a67ae7867813b638b9fa66579f51e8ce145e7747e9745b3fe50d5"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "584ce9e1f496db74be01e358e6a899348332355587d81224ba48b4b3cc16fb77" => :mojave
    sha256 "7d387aa6e0b0d1b12afab75b46975f93c844298fc932956f7c5d2bb650e1d706" => :high_sierra
    sha256 "0f7f6b7fae3400d0090e6fbef1dce0eaf810cbe66ee5c8a839ca6013c1bf2135" => :sierra
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
