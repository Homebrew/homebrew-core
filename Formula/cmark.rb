class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.29.0.tar.gz"
  sha256 "2558ace3cbeff85610de3bda32858f722b359acdadf0c4691851865bb84924a6"
  license "BSD-2-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "ebd4950efccf01f8289486df7fa7ccb4af6fa851f3780d8684089015ca312fe4" => :big_sur
    sha256 "ca089ca505933fd9e99555cbb8674994e622300a772a602edc31b670cabd6a50" => :arm64_big_sur
    sha256 "bac8513461f194c42c622ad7ec947e29c12ad297e7d8a484e1fbe85ebc34e68b" => :catalina
    sha256 "1a539a85b286c90328c6369631229e479129587b2fe7787dc023d983b9773788" => :mojave
    sha256 "08672a685877aab6625cb400fc56b73cc370f0006eb9b0befbd7e6a11569ceae" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
