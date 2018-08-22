class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.15.tar.gz"
  version "0.28.3.gfm.15"
  sha256 "9e43c0b5dbd6678059fb7eeb5f57520b480812083b91567034c9e2890cc32f21"

  bottle do
    cellar :any
    sha256 "5c276f3e8d20e2a313180a17d83fae70e1d0963377a212b3a63fef5d3ceb4137" => :high_sierra
    sha256 "8bd871eb8125887e6f371cf6faa5732540039158b89c8b96e6eec3ba2c00f24d" => :sierra
    sha256 "9806bb5aa40a4fe4f5c8391b0fe9349c05baaa84f6fe929d3fc2f7c1ef66fa33" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

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
