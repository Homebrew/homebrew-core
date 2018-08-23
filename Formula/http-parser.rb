class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.8.1.tar.gz"
  sha256 "51615f68b8d67eadfd2482decc63b3e55d749ce0055502bbb5b0032726d22d96"

  bottle do
    cellar :any
    sha256 "327ccd7d4ada0dce46e116ec2c26b3f931c7f2ef88d849a76d14f7d8798e3753" => :mojave
    sha256 "7178c5fe4dc5c38d129d81f7abc654919e8ac0a7dbe33e9409e765258deef09f" => :high_sierra
    sha256 "c4ad12da88940514f531b5cb1c13ee8aab7e069ac1680b391d5bd74b7fc1ec86" => :sierra
    sha256 "6f80645e6e13d73eb0521daf7f244492015767110cd1282ccc8c827c5b97c5b0" => :el_capitan
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
