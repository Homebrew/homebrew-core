class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.6.tar.gz"
  sha256 "36298549deab66b4b9bb274ecbe74514bb7c83f309265f8f649cf49a44b9bd9f"

  bottle do
    cellar :any
    sha256 "b7944cd116f04d17eede59d961ac32bdd7b7a9aa54abdff274aa1d1b12e24c36" => :high_sierra
    sha256 "036cbf9e1a4b663fb2e27382f1e57500ad6f4d3f7f3d0c81219ea6ae109ebdda" => :sierra
    sha256 "a4fa93d5c6d6bd2c009387a47773226a6bbbb88db366de988063fcda8dd60989" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert File.exist?("test.m4a")
  end
end
