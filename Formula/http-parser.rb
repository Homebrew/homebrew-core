class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.9.0.tar.gz"
  sha256 "ef26268c54c8084d17654ba2ed5140bffeffd2a040a895ffb22a6cca3f6c613f"

  bottle do
    cellar :any
    sha256 "242b417541f72de37926aae62fbac844979b9fa90476f9f6ffa78b6cb873a64e" => :mojave
    sha256 "99cedc5e49ceb95e70ff222a075ee75a236dbe64abc023735d3e896c47f14f92" => :high_sierra
    sha256 "51dad153c5f7a727336517a92a6f36b41a8b8b66610cb20843d45f8538b8c5ae" => :sierra
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
