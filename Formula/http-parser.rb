class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.9.2.tar.gz"
  sha256 "5199500e352584852c95c13423edc5f0cb329297c81dd69c3c8f52a75496da08"

  bottle do
    cellar :any
    sha256 "d98b4f844eea5f9691789778c8ffa4626298c545f5451eed1c880efb68b04fae" => :catalina
    sha256 "1c6633009d218a0a991e42aa79ae824831a796b27ebe107166f718b169fb51d4" => :mojave
    sha256 "557d24ba21e7be4cc6dbc2e7c2da15338f45bf8b61dcc3791e6b2054b3498512" => :high_sierra
    sha256 "4337dc4318708e9342e0299c6cbc199ab58c15886a72b2dd1c9e6021effc386f" => :sierra
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
