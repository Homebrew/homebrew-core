class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.0.tar.gz"
  version "0.29.0.gfm.0"
  sha256 "6a94aeaa59a583fadcbf28de81dea8641b3f56d935dda5b2447a3c8df6c95fea"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "bce67909783f14886f3c68195fa316e12019208e07a2893ece68bce3ab421014" => :catalina
    sha256 "08cd69b6691e7f38c84c85272f39ce900d0cb7e8270218e48da25068da5fce2e" => :mojave
    sha256 "c5b7a2ec9f938dc64d3bccead2e1b7fcb1d21de9404b0e33e433e2d0e6379243" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
