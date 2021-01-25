class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/v0.5.tar.gz"
  sha256 "7eea99dbf9c86698b5b00ad7f0675b9327098112bf5c11f1bad0635077eae8a9"
  license "LGPL-3.0"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "30bb9dd29ed877e48308f66be15ef43b2816e9a38b346a2e04b280ab64e677c9" => :big_sur
    sha256 "7383b095117bbcb658bb4563a709509bc01b4a3e747cf74c394fadb39a677300" => :arm64_big_sur
    sha256 "e6aea4db0e3298e04dfbb215bcedcc4302d76965f82b4dfc921636dbc24ff939" => :catalina
    sha256 "0c63e8d53c61bcda8452501c584b2f06919054f4e447fa9ce8c929b0bee50d24" => :mojave
    sha256 "a4169631c0ac82995409931836ea16664618d37650337e994bfea7121a386791" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  patch do
    url "https://github.com/jtsiomb/libdrawtext/commit/543cfc67beb76e2c25df0a329b5d38eff9d36c71.patch?full_index=1"
    sha256 "dd6a78d2c982215b91fcb6fba9d00311b09a8eea26564f7710daabc744c3be09"
  end

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tools/font2glyphmap"
    system "make", "-C", "tools/font2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    ext = (MacOS.version >= :high_sierra) ? "otf" : "ttf"
    cp "/System/Library/Fonts/LastResort.#{ext}", testpath
    system bin/"font2glyphmap", "LastResort.#{ext}"
    bytes = File.read("LastResort_s12.glyphmap").bytes.to_a[0..12]
    assert_equal [80, 53, 10, 53, 49, 50, 32, 53, 49, 50, 10, 35, 32], bytes
  end
end
