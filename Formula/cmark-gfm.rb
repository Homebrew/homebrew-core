class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.3.tar.gz"
  version "0.29.0.gfm.3"
  sha256 "56fba15e63676c756566743dcd43c61c6a77cc1d17ad8be88a56452276ba4d4c"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "884ea077983251b7212dcda36413dc028ab39dfd12427f955236f16a02f8e8c8"
    sha256 cellar: :any,                 arm64_big_sur:  "cb732cbea0738d7488da9e5bb2694d87bf1a18db9c39eed7bae428e7b7d7c79a"
    sha256 cellar: :any,                 monterey:       "20d3b7cdb732305873fb9a9fccee3c971383a4172e792bfc89c9b0457532ef81"
    sha256 cellar: :any,                 big_sur:        "0d3a07d3aa0c2498ad2e095e0ee4879b2d56282f9a935e7720dce864b92b4eb1"
    sha256 cellar: :any,                 catalina:       "e955d7646385f7b8fc87ca4b5b253ffee1b9f56036fcdc49d850d04bd7a0c1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac57b71b5630072f81e9a76b22736ce112336681a8b2a2fd84ea87f942cb277f"
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
