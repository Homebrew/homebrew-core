class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.5.tar.gz"
  sha256 "a9c36c49d6956eb78d062768927a87014dbb04573d7ce38e50a65a4772fc8016"

  bottle do
    cellar :any
    sha256 "b7944cd116f04d17eede59d961ac32bdd7b7a9aa54abdff274aa1d1b12e24c36" => :high_sierra
    sha256 "036cbf9e1a4b663fb2e27382f1e57500ad6f4d3f7f3d0c81219ea6ae109ebdda" => :sierra
    sha256 "a4fa93d5c6d6bd2c009387a47773226a6bbbb88db366de988063fcda8dd60989" => :el_capitan
  end

  # Remove for > 1.29.7.5
  # Fix "error: initializer element is not a compile-time constant"
  # Upstream commit from 23 Sep 2017 https://sourceforge.net/p/faac/faac/ci/4036f2c85038ef199a4636a6cbc4448f5e914d39
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6f36b35/faac/clang-compatibility-fix.patch"
    sha256 "aab5d3636e6fe135b0137d2ea5f3800b3edf0225fa305a968ccabe92cf031e3f"
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
