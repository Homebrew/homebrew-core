class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.4.tar.gz"
  version "0.29.0.gfm.4"
  sha256 "1be0d2c703b87cfbf51f91336db04039756e118c39398a392b9a3cca1b7d4ead"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3fce983843324792b1a4df8be5b242fc0cee23200e7015141bf12ef36ca5f2a9"
    sha256 cellar: :any,                 arm64_big_sur:  "ddf818d97cc545f1c13b7613109f45786a3c2b653b2b148b36ecb40fb48af04e"
    sha256 cellar: :any,                 monterey:       "dc4f61c2d6e50fc750f3b82404bda9bc4ce9f47f6415722b78dc75cf8216b77d"
    sha256 cellar: :any,                 big_sur:        "6f342b5088afeeeee23b0ea4fed9bc0ef4f46ad5532985fe93a2c131c37c9d2c"
    sha256 cellar: :any,                 catalina:       "8c99f03ce18b3c4fdc9e836e8c3fc1054883c9fd7fd4f98be1e87d2b09a86c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c19ca94d92227351f56497a01faa27f20a30cdbe04a8c8636f6d55da0a044e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
