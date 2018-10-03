class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.0.tar.gz"
  sha256 "7120b25a74b2bec99d75238c235e440f5338d53ad64a4cfe4d05e65814ac91d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e4e6c646db9a2f18743618e221a45deb5a2a14a3204a62a07081b5f6123c079" => :mojave
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
