class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/v0.5.tar.gz"
  sha256 "7eea99dbf9c86698b5b00ad7f0675b9327098112bf5c11f1bad0635077eae8a9"
  license "LGPL-3.0"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "e6aea4db0e3298e04dfbb215bcedcc4302d76965f82b4dfc921636dbc24ff939" => :catalina
    sha256 "0c63e8d53c61bcda8452501c584b2f06919054f4e447fa9ce8c929b0bee50d24" => :mojave
    sha256 "a4169631c0ac82995409931836ea16664618d37650337e994bfea7121a386791" => :high_sierra
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
    assert_equal [80, 53, 10, 53, 49, 50, 32, 53, 49, 50, 10, 35, 32], bytes
  end
end
