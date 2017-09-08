class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.0.gfm.10.tar.gz"
  version "0.28.0.gfm.10"
  sha256 "ce318ae6b7b4d995644c6a97f86307051aa86ffefaa8cf6449a87bcdfb1e65c5"

  bottle do
    cellar :any
    sha256 "4b7556ea467c15595a2f2e4eb296febcd1a1638eb61faca01ee70142b7e818fd" => :sierra
    sha256 "edb5028817009d38717198fdd9513cbd67d5cf899751716f0391f86a3aae1a66" => :el_capitan
    sha256 "e8fe246fc6a52444fdd6d4708f5646448bb43a07978b2e75b58bf76471b76f44" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
