class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.12.tar.gz"
  version "0.28.3.gfm.12"
  sha256 "7f53d060a82df012859ae3493c62e2d63b8146cbea8af77e696cde41a62d7246"

  bottle do
    cellar :any
    sha256 "f8fb24d78f6a8e48aef311e5623a98cef25fc0f12c88742964b3ba7194831b60" => :high_sierra
    sha256 "b94090c9e3be2b4699c17059d5c57b2c732c2d274f90d80cadb049c3c1556ab7" => :sierra
    sha256 "e5f4de22de172dec649fcc453022fe33840d3b0596b2ab830d2a0525d5c02ccd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python3" => :build

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
