class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.15.tar.gz"
  version "0.28.3.gfm.15"
  sha256 "9e43c0b5dbd6678059fb7eeb5f57520b480812083b91567034c9e2890cc32f21"

  bottle do
    cellar :any
    sha256 "2d889bbff7838c29b21ee2c1b9c7ee11c5616ea95966932c6d6eb784c7fd4ac8" => :mojave
    sha256 "533aec7829f97a23782c5f83e5d4e26e5c85e2d3f46590a7e5278d5ed5917f11" => :high_sierra
    sha256 "327446943731204a480b743ce2b240b674cb16979980b4856331e57479925748" => :sierra
    sha256 "f7ead409075227c7c42c1ee498a8d8806ad8055e0adcdc5ac176314d45e8fd1f" => :el_capitan
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
