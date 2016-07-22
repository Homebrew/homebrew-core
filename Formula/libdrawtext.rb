class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/release_0.4.tar.gz"
  sha256 "e9460eb489e0ef6d1496afed2dae2e41c94005c85737ff53a8c09d51b6f93074"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "f5c51bafda51fd4eef0efccbac103b0bac2ed8fbc63598103af30fdeb909b348" => :el_capitan
    sha256 "1a46fde01f6b2baaba7148fbbc6b985226aa22a7ba75876028c2e132c6f1cec8" => :yosemite
    sha256 "0a966d7100b428330d3c3eeadc2cceb6d9e580943ee06a04d89afff9aff28ce3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tools/font2glyphmap"
    system "make", "-C", "tools/font2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    cp "/System/Library/Fonts/LastResort.ttf", testpath
    system bin/"font2glyphmap", "LastResort.ttf"
    bytes = File.read("LastResort_s12.glyphmap").bytes.to_a[0..12]
    assert_equal [80, 54, 10, 53, 49, 50, 32, 50, 53, 54, 10, 35, 32], bytes
  end
end
