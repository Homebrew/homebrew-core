class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.12.2-src.tar.gz"
  sha256 "bb031c48039ee73ea0e60709bb9ab80c55bfa3a5920b798ea37a03f2757b099c"
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    sha256 "abdd1c8fa2450b5ee05aebc0ca23c0af892365efaed1e289e437ddc85ee89788" => :mojave
    sha256 "f052f75b1b03c360dfa13a80322c5e24d60e74d7e330cc77c29e7a9ea9dfcc0b" => :high_sierra
    sha256 "cbd79a30ce1a5302c158bb623d79e90d4637f0a4267973731fa1501c6351adb8" => :sierra
    sha256 "62aca3d86ea5a1a8db27cb073f3ed715e53d1734981d14124019eddd419cb60c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
