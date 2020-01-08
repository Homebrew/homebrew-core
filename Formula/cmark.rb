class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.29.0.tar.gz"
  sha256 "2558ace3cbeff85610de3bda32858f722b359acdadf0c4691851865bb84924a6"

  bottle do
    cellar :any
    sha256 "d7bf29e64f91198441f39325653aa12ab7d4bbeb458a337146039717394cce2e" => :catalina
    sha256 "8687e5aeca18f2c952c5f475569ad90f077d49c3e45477cad0babd68b040a6cb" => :mojave
    sha256 "81e1fe130cae57abb515a8916140b3b2718f4f9ae778fe059d454d51cc24e1b3" => :high_sierra
    sha256 "ffe7ff1b15e9d7283253129feb78db9d9ccd72f39388a33331fbe8d0fb7445a4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
