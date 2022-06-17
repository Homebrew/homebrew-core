class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.12.tar.gz"
  sha256 "ba89fb167a5ab6bbdfa6ee3b1a71636e8140fa8471cce8a311697584948e4d06"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b705b568acda1df8d65c46dc14d4738606bda7b7475858c13111a832cec0c3b1"
    sha256 cellar: :any,                 arm64_big_sur:  "04c038659dee2a06d9eb900f2c6ce197a0313ba5bd14921eac8d0c16b927d9dc"
    sha256 cellar: :any,                 monterey:       "070dd0f6f6e1213a32c79c5b2f7e13dbc9a4cab06a91802ed09698eb40061aa5"
    sha256 cellar: :any,                 big_sur:        "84816f7976c5164a0941564da44c07eba70313ffa632b5d2a590441e6e3a4183"
    sha256 cellar: :any,                 catalina:       "d1d36bb1a1c09bd9ca61eec0531b4b54ecc3859d8f486ae018160e8f8ceced2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2869aed0ec20ac527b682c7db3bfea798e7829a68ff04804f75be270faf0a4d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
