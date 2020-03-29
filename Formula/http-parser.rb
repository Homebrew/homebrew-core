class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.9.4.tar.gz"
  sha256 "467b9e30fd0979ee301065e70f637d525c28193449e1b13fbcb1b1fab3ad224f"

  bottle do
    cellar :any
    sha256 "f03615a5ecb9e65d4bd7b302a8429ba9130012b092f3f42e0afd85df2bf47453" => :catalina
    sha256 "b36ae811b2b72823cea4c7ab445ee2a5f628255aa169f0bc453fda1d3d520fbb" => :mojave
    sha256 "0c6b69289fa4a8dd7ad532fcefb0848af229dcb5a64df981c03e99af2ce3acd8" => :high_sierra
  end

  depends_on "coreutils" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
    pkgshare.install "test.c"
  end

  test do
    # Set HTTP_PARSER_STRICT=0 to bypass "tab in URL" test on macOS
    system ENV.cc, pkgshare/"test.c", "-o", "test", "-L#{lib}", "-lhttp_parser",
           "-DHTTP_PARSER_STRICT=0"
    system "./test"
  end
end
