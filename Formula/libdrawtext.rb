class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/v0.5.tar.gz"
  sha256 "7eea99dbf9c86698b5b00ad7f0675b9327098112bf5c11f1bad0635077eae8a9"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "62b2abf2b3daeb3832174f342b63d9b684f9c5314305dcd53aedc20c64be9cf3" => :mojave
    sha256 "56701e24e6d2d89dfab1e6857ee450394ca155409e659d87578874e5dcb09fdc" => :high_sierra
    sha256 "b964ecf876b0e7118dbc8f6b39f0295f3f93244db5109d512258f0f036975e9b" => :sierra
    sha256 "f0ea7bf5a4ddaa71eabcf015be0c774a707eb44c0bab20dbb87633f3fbe11941" => :el_capitan
    sha256 "9aa0cb7f932e819bf07d4da05a5e134bb0dbce0aa07057a78af14ae03ef2423f" => :yosemite
    sha256 "e734a70c82a43accad6adc21b747accce048efb521f04f03767ddaa16ffc53e4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  patch do
    url "https://github.com/jtsiomb/libdrawtext/commit/543cfc67beb76e2c25df0a329b5d38eff9d36c71.diff?full_index=1"
    sha256 "a2d7ad77e7f1a4590ca85754de2f9961c921c34723f6c86cdd23395cc3566be0"
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
    assert_equal [80, 54, 10, 53, 49, 50, 32, 50, 53, 54, 10, 35, 32], bytes
  end
end
