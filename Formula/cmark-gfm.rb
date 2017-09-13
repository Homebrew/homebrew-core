class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.0.gfm.11.tar.gz"
  version "0.28.0.gfm.11"
  sha256 "a95ee221c3f6d718bbb38bede95f05f05e07827f8f3c29ed6cb09ddb7d05c2cd"

  bottle do
    cellar :any
    sha256 "5d1fde1c85b5943daa7fd82b64d936e346aff200126df9ce51fdfc7958a0eba3" => :sierra
    sha256 "f5ea53570cbe88230ecd4afa5679c1e3567c0c8280d3e1748fdd2c9ef4164f34" => :el_capitan
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
