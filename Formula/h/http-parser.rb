class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "467b9e30fd0979ee301065e70f637d525c28193449e1b13fbcb1b1fab3ad224f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efaa9e1c93c49751d87a7720f20e87753b08495744cc3018b48a096d5bb9f971"
    sha256 cellar: :any,                 arm64_ventura:  "1f6568eb982eaf9c9e6b42cc382fcb7241089ace5775a18434d06b05e295e9d2"
    sha256 cellar: :any,                 arm64_monterey: "2af85f7a77c43361923e3c334079b393d76525c60cd2844c77da32aeb71ea72d"
    sha256 cellar: :any,                 arm64_big_sur:  "7130d0b0338eaf592eb0510251f95a8a4e580ef9ecc4eaf787ba048204639498"
    sha256 cellar: :any,                 sonoma:         "de5c6d3abb6d2e147b83c43de7348705e1d5efd89ecc2a12d51fce413c30c302"
    sha256 cellar: :any,                 ventura:        "254dac839c15f32e4e4a03a7c695cd7b99b53c7a296c58eba06cfb15d00b0e82"
    sha256 cellar: :any,                 monterey:       "d4530aca738bc5328a8dc135320588a549997d6df090cf8acbaad32e7ec17ca1"
    sha256 cellar: :any,                 big_sur:        "48d383aa989a940b3918cc83fa2bb6b5fad92c9b4c70018172d36f9e465087e3"
    sha256 cellar: :any,                 catalina:       "f03615a5ecb9e65d4bd7b302a8429ba9130012b092f3f42e0afd85df2bf47453"
    sha256 cellar: :any,                 mojave:         "b36ae811b2b72823cea4c7ab445ee2a5f628255aa169f0bc453fda1d3d520fbb"
    sha256 cellar: :any,                 high_sierra:    "0c6b69289fa4a8dd7ad532fcefb0848af229dcb5a64df981c03e99af2ce3acd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d431f1e2e5f0a301e813e270df42aa3a66f16a791bdbf929bc40d0c0270229"
  end

  # "http-parser is not actively maintained. New projects and projects looking
  # to migrate should consider llhttp (https://github.com/nodejs/llhttp)."
  disable! date: "2024-01-12", because: :repo_archived

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
