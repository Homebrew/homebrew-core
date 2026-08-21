class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/releases/download/2.0.0/libhttpserver-2.0.0.tar.gz"
  sha256 "d6cb4169605826514ccb1a4ed83e1e9a879a9156c463b6f7950ec7878a223214"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce049b8ca9b898ddc3b94df124cbe4aa099863451754673635bcf53dbba11806"
    sha256 cellar: :any, arm64_sequoia: "5ac30712b5e68e4dafd1786ddd01d3982cdbc3b90b1cf125a0c2b5d5f54c7388"
    sha256 cellar: :any, arm64_sonoma:  "d5f2ea59d891549b8cc484ab7b4d62e9266800c8127864a7acddcee9f2b4bb9c"
    sha256 cellar: :any, sonoma:        "86b5fca83e830ba48d4daf685ddea314a088c80b52d6a01851f4b5db2fd6db68"
    sha256 cellar: :any, arm64_linux:   "9f1b216381844bd86f626b1b9b3a01b5b9875f036219c16d34ccbb1e272b03c9"
    sha256 cellar: :any, x86_64_linux:  "6908ced57ead5ffd6c8075e06b7acb90c54417aa459c89f9ba6286a41aecec71"
  end

  head do
    url "https://github.com/etr/libhttpserver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libmicrohttpd"

  uses_from_macos "curl" => :test

  def install
    system "./bootstrap" if build.head?
    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    port = free_port

    cp pkgshare/"examples/hello_world.cpp", testpath
    inreplace "hello_world.cpp", "create_webserver(8080)", "create_webserver(#{port})"

    system ENV.cxx, "hello_world.cpp",
      "-std=c++20", "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"

    spawn "./hello_world"
    sleep 3
    sleep 5 if OS.mac? && Hardware::CPU.intel?

    assert_match "Hello, World!", shell_output("curl http://127.0.0.1:#{port}/hello")
  end
end
