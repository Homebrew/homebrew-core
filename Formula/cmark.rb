class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.1.tar.gz"
  sha256 "9609506bd7473e769452488ef981eb53f082011b1ec6c9b6c73ed57062e25ee6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec28a38ef4b4258032a844a6187a53e57066275e3b10f8e65ce4fb5700c94f9d"
    sha256 cellar: :any,                 big_sur:       "65f35e66526411e2395b4999db27d59583e3560d405e22b3c61e37c32a108bbe"
    sha256 cellar: :any,                 catalina:      "fe9a9768097191a61fa9cc4547f537b96b57628d543af20b4090a99b3d436675"
    sha256 cellar: :any,                 mojave:        "83385257cf867a29845c112fefea84e7648fdf0414ce3c519634985e008bc8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd63b0ce8bc3056aba365a89b5608f6e6f0c8304ba08159928c9e88c094b6ac"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

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
