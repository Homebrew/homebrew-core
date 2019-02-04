class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/0.17.5.tar.gz"
  sha256 "778fa0aec199bf8737b2d540c2563a694c18957329f9885e372f7aaafb838351"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "6e0d1e5fe0104d2a9d150f4f81ea42eb9dec5461134be0147695e82a068cc759" => :mojave
    sha256 "8d9bce68365de7465bbd983c2979e1b7ab2c2a935212bb4df80a7b796a2abe73" => :high_sierra
    sha256 "71a6c56c4791538751ddf8a4ca08d257cb8575ab10d664699e9f1ad5e04f24c3" => :sierra
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
      "-std=c++11", "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"
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
