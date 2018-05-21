class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v1.9.tar.gz"
  sha256 "5d075deaef087680ea4c153ed5f0696f8be149a59ce0e5aaeb3f5b1180b2ec81"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c00afb8282817dbd475d0611972a67583e38b61aba69197c754443a1c65c2fc" => :high_sierra
    sha256 "1a192e98388164010d63d19f9f858bc6c60473ce0abe1b3aea21130f5b2f366d" => :sierra
    sha256 "4b75a0f2083440568deecc1328a1106617f8dbd3342a558e755109b00aa6fbfc" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
