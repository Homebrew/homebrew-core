class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.8.0.tar.gz"
  sha256 "7277c6f99bf6fc272eb5d8fc3dca01e7cc1d4ae609b5d2c5d5e18added98479d"

  bottle do
    cellar :any
    sha256 "8d947716ab99942defcc8d203b280c0ca7a5cd0b6018af587f612e614a7de3ef" => :high_sierra
    sha256 "540d616067151c375286cdd702cdfe39e9899f9039a4c878da033ef5e3b45e2d" => :sierra
    sha256 "1de8b816c634439df2e5d24e5f8747c4d3a2294d2d2a6c3bfab0a5af68d044c7" => :el_capitan
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
