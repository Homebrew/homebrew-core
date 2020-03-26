class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.9.4.tar.gz"
  sha256 "467b9e30fd0979ee301065e70f637d525c28193449e1b13fbcb1b1fab3ad224f"

  bottle do
    cellar :any
    sha256 "5553b0b22087bb034e3a1f938d1e3702d978a0d10f23276b614ab44dc9b7fb06" => :catalina
    sha256 "6cc277c477616992456130af984a71e32d0ac28881e9d7110323d5eb234e7911" => :mojave
    sha256 "55293e78decc0e7c3d1c98a942b96eaebf4c0af33973df4269a647c79cc783d3" => :high_sierra
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
