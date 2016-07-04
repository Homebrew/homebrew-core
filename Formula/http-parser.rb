class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.7.0.tar.gz"
  sha256 "b0c5bf03fe9a57c4e63760d19d5a51d3063e0502cae54b3a8f2f6c6eb6911167"

  bottle do
    cellar :any
    sha256 "82cc8e2414874405c0094ccc0b7a088f2810818fa18e9337496833a0b4cd8ff1" => :el_capitan
    sha256 "68ef67363b039b874239e6484119ff8608b286cf723873328882420e2c30493e" => :yosemite
    sha256 "5a362ade2a85e84c96356dc5ce5afaa9c615f6445a86f74ebd837ea261b2cc64" => :mavericks
  end

  depends_on "coreutils" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
    share.install "test.c"
  end

  test do
    # Set HTTP_PARSER_STRICT=0 to bypass "tab in URL" test on OS X
    system ENV.cc, share/"test.c", "-o", "test", "-lhttp_parser", "-DHTTP_PARSER_STRICT=0"
    system "./test"
  end
end
