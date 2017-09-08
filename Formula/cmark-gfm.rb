class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.0.gfm.10.tar.gz"
  version "0.28.0.gfm.10"
  sha256 "ce318ae6b7b4d995644c6a97f86307051aa86ffefaa8cf6449a87bcdfb1e65c5"

  bottle do
    cellar :any
    sha256 "a554bb3a0d3350bef2f4f8c01acd57d27772b70d1d655b7ad9eaee72518932f8" => :sierra
    sha256 "a48a799bc46f89ba524a24f4ef57d89f0e848caaa00261c41006fbdc6fb957a3" => :el_capitan
    sha256 "4b635562f57f2c5ad45be5d4d1512d7e103468ee3a4f69b5bade210c57322e61" => :yosemite
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
