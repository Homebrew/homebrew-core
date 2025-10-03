class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/refs/tags/0.31.1.tar.gz"
  sha256 "3da93db5469c30588cfeb283d9d62edfc6ded9eb0edc10a4f5bbfb7d722ea802"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8af79b78d1aa446d6c5532ec3553358c627f8a0b7cdfc2ea8663748e860cbe72"
    sha256 cellar: :any,                 arm64_sequoia: "93bab92b2ba9b451da62ad4a762d078cafc8d4e400c23a7322f2f9dd9fcc8ea3"
    sha256 cellar: :any,                 arm64_sonoma:  "06bf4e3da615bfa454360952b105d18bdc02ad6191220845bd3a6a776769da87"
    sha256 cellar: :any,                 arm64_ventura: "4381cbbe681dbf83352e58b8b0fdfafed4610e8017f8fb62c1e1769d90916431"
    sha256 cellar: :any,                 sonoma:        "42a5bb96e297ac635bea30d77ee9a80f7b7c5ae4c810ba3a1c34aca53e87d4aa"
    sha256 cellar: :any,                 ventura:       "b00c642cf2f806489f91071dfcf1bc20fcf342154a8bf21a60563639694232c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e16d3511204042385b697dfd4df300f5dd6114dbe86316ca93b03d1260375d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a6fd552de7099141ad135382c032bed8efa0714e91ec20490c1e05342ec5fa"
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
