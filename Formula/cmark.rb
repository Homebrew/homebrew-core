class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.2.tar.gz"
  sha256 "6c7d2bcaea1433d977d8fed0b55b71c9d045a7cdf616e3cd2dce9007da753db3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1fa03a664d685aef0da9a3aa66df403618a037dbf3e633ce2b9c1216d38808a"
    sha256 cellar: :any,                 arm64_big_sur:  "b5c6f7afba617f9886ba3f16fed0aeccee9f2c72d105236f995986f8ed5daaa6"
    sha256 cellar: :any,                 monterey:       "0a53b1a9645e2b45e8e109d51d65f044d109ecc23b97b4c63ae2fc6b8f030165"
    sha256 cellar: :any,                 big_sur:        "957b224ea8c9f23b3260013bf9f60d475cd9a0577ed9fede5ff096ed6035a9b1"
    sha256 cellar: :any,                 catalina:       "59254ee4c9602976612648c361ccc1288e4af8caca6a1ec5f12b263be1f0944d"
    sha256 cellar: :any,                 mojave:         "a4ec36e7473ba3fb80859464f712b9848c86fbd7979137d063ae3f1e7458784e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a519030b76311ae6e1a5772b9e19aad6e3e80ed9edc48b520946e58ab9d5320b"
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
