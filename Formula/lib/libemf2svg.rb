class Libemf2svg < Formula
  desc "Microsoft (MS) EMF to SVG conversion library"
  homepage "https://github.com/kakwa/libemf2svg"
  url "https://github.com/kakwa/libemf2svg/archive/refs/tags/1.1.0.tar.gz"
  sha256 "ad48d2de9d1f4172aca475d9220bbd152b7280f98642db561ee6688faf50cd1e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1fc992a4391b5890a2163b4019c36331fb462f79a0fc77bfeb4c06e5a4641d73"
    sha256 cellar: :any, arm64_monterey: "5c433d7a620912bb39e0a09a8f9d793028bf6c671a716d8e6f7f63cdf797aaa9"
    sha256 cellar: :any, arm64_big_sur:  "063dce921f40a941dccf3d79c1e886dc9944bda2166b9a840f5a6a80d37ffb6d"
    sha256 cellar: :any, ventura:        "e70b11b9736140938aac03fe053af3312cb992cc7aeb3a5a48573c2fd1b4eb69"
    sha256 cellar: :any, monterey:       "282508d66b3fd198648a798040205d7f3e42720cc9fc64572ac397767b369851"
    sha256 cellar: :any, big_sur:        "2da6c337708d8666ddfd4295b77f81b72c099f31c564f4efd79bed5f620a0d7a"
    sha256 cellar: :any, catalina:       "22a0d2002ff89d8583fa86c103d465b23fe7809a527aae4c6dad29b39db020f5"
  end

  depends_on "argp-standalone" => :build
  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"

  resource "homebrew-testdata" do
    url "https://github.com/kakwa/libemf2svg/raw/1.1.0/tests/resources/emf/test-037.emf"
    sha256 "d2855fc380fc3f791da58a78937af60c77ea437b749702a90652615019a5abdf"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-testdata").stage do
      system "#{bin}/emf2svg-conv", "-i", "test-037.emf", "-o", testpath/"test.svg"
    end
    assert_predicate testpath/"test.svg", :exist?
  end
end
