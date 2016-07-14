class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/release_0.4.tar.gz"
  sha256 "e9460eb489e0ef6d1496afed2dae2e41c94005c85737ff53a8c09d51b6f93074"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "c8fec5b5b1598f63ddcfbe5b1b74a782ae40f664edbd1073aa7e80a4896d628b" => :el_capitan
    sha256 "6ae003ec108b3ea6a09472339e749ee169e16a5840348d7c4ca5c963e1e8db91" => :yosemite
    sha256 "a6f88eda7040bca6f9857aacfca149eb6f1d2a022965b15f52cdb8e98271f4ae" => :mavericks
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
