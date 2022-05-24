class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.2.tar.gz"
  sha256 "6c7d2bcaea1433d977d8fed0b55b71c9d045a7cdf616e3cd2dce9007da753db3"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "088cdde54f9999dc34fdcc788b85052c9b58db6b4379ab601cffa7a41d936c94"
    sha256 cellar: :any,                 arm64_big_sur:  "69c90d2fad0777d9f38bcab5c57384907dad0695e4feeb8416fba20f22f900e2"
    sha256 cellar: :any,                 monterey:       "d48785695ca7b81ad1d36a7c97b032d8499a6025f8f230884e9ddaa816f46181"
    sha256 cellar: :any,                 big_sur:        "458ddb5baf0452ffbeba28aa890836273ef1b880b5f729c0cc0466cd7e12ccd7"
    sha256 cellar: :any,                 catalina:       "d5da6294f5f07fe987edab4b8c51a7b7a76a4e9c4c268635d1d08644f21a05fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1072f9aa1474190ea218ae7243ad432d71a3868edd55d19c6102d2e691a4ca1"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
