class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.11.tar.gz"
  version "0.29.0.gfm.11"
  sha256 "8fece1cbc28c82fe61ae0b76cae971b9fedba6f32911e6787e58d6fe03e65533"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea0bcc27cef4136a4e995563eceb9f2cf1e39f5b395790cc6e2065aa5a0dfbf5"
    sha256 cellar: :any,                 arm64_monterey: "ddacedb33b4b708a8db654ad57b7849c4178ac1091f246df766cbed661e80b7b"
    sha256 cellar: :any,                 arm64_big_sur:  "9a76186b696368dbe609cee7f8592db1f7fc81b0e4d27db9aea92ff57f99dc92"
    sha256 cellar: :any,                 ventura:        "27158fb1976883afe5b9469dc6483f02954c570bdf61b1f7c91cbc957f6e4b26"
    sha256 cellar: :any,                 monterey:       "d764dd24b02dc3e7bc79932d7feb3737d053d1ad804458fc1b7ec830a3fdcd6c"
    sha256 cellar: :any,                 big_sur:        "f95c12caeff313b24130ed732f1c2e2649db620e20381a7efdfdcaed875533d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0ee03da9f5400c25e04c6cfb181f6b75253bfca74d3a88b22b435356440648"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
