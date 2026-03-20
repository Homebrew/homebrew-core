class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/refs/tags/0.31.2.tar.gz"
  sha256 "f9bc5ca38bcb0b727f0056100fac4d743e768872e3bacec7746de28f5700d697"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23df2262fb8ef016f8f60bdfcd875a08de7f184f60c2263991c79af9cd772ae6"
    sha256 cellar: :any,                 arm64_sequoia: "91068cdaa2e4a69d056cf074c5e4b74737b749c40a4c3ee9fba0db317cdc4761"
    sha256 cellar: :any,                 arm64_sonoma:  "42f38683fb7789c186d4ffff629a423421fdb332d1265e5d738d6d104ca14e22"
    sha256 cellar: :any,                 sonoma:        "768afbf8cba6067e2c4935dfaf79c3fab51bd0561c0daebb126b6501d63054a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d653712866e26d9a1ccc17543cb7d88e6419ed94c5cc7617e25692482ec9b99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4c24cef6d576e564ddcb2660e6796d73d76a656966d75075e2113088e4efac"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output(bin/"cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
