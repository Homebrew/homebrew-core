class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.29.0.tar.gz"
  sha256 "2558ace3cbeff85610de3bda32858f722b359acdadf0c4691851865bb84924a6"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "3af95418f96f4b0cec4bd76abaab312f3caf4cea591f38d3b725f15068d06491" => :catalina
    sha256 "7cbb32d00d44170f5fe426cf2f1d4b5d756738b18631a13f8c5f94524b39f73b" => :mojave
    sha256 "fb673191d96707019c8eefc224de72045149830f445fb7340c454cc6e8510981" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

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
