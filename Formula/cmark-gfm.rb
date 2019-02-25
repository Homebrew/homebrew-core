class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.28.3.gfm.20.tar.gz"
  version "0.28.3.gfm.20"
  sha256 "483ed2c0eb3b8bdbcb0679c4e6f471c8e351d320cd310c22cbf01a83943a4785"

  bottle do
    cellar :any
    sha256 "d1df85020bd4e0d7a60614c5c3819f05d6d180e73c68908eeff228895965c763" => :mojave
    sha256 "a8354c2f178548925a8b9a987b0b612453b5047981be19f07569de18ce9f48ef" => :high_sierra
    sha256 "cdf63218b2aa503893774d7cae7d2c9c25e001acc3b4df61ea9318a63a4a8c27" => :sierra
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
