class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v1.9.tar.gz"
  sha256 "5d075deaef087680ea4c153ed5f0696f8be149a59ce0e5aaeb3f5b1180b2ec81"

  bottle do
    cellar :any_skip_relocation
    sha256 "72ceaeadbac4af0bb864ba38664fa348bda14ea4083c07a13ecd219466450b12" => :high_sierra
    sha256 "48310c1a3421d0d94dc205927b5f36daa5eae939b337e110630a03743feb76ad" => :sierra
    sha256 "a65d60bce6a1b902a84e3840ea74228be5c9ffe0e1b9fc2c3ed6aa5a3907d0c7" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
