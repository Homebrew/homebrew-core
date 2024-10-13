class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.8.tar.xz"
  sha256 "5e8c3c4bc2d4c0a40aef6b4b38ed2fb74301640da29f6528154b5009b1c6dd49"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "17ba5e2b020b84a364c0f219ffa9ab7b77d4dc70a44a410ae2c499becb4e82be"
    sha256 cellar: :any,                 arm64_sonoma:   "d95c5112b3882586fcf34944967868b13d7f0cb52ee8156b38618320a2e8bf2c"
    sha256 cellar: :any,                 arm64_ventura:  "5818956cf6b0385d6e8b56f7e2e07b4677e75146015644eb76c3b0f60a1cc313"
    sha256 cellar: :any,                 arm64_monterey: "21e2ea56dd4cf339e625262a1e159228ed73b5bf5876fa00417f6b4f4ed9e240"
    sha256 cellar: :any,                 arm64_big_sur:  "4b79cdbc8fe2c488ca301e86c87c6fe1b18fb5e196d3e26faa054601b7ebdecd"
    sha256 cellar: :any,                 sonoma:         "4b3409481b684033a67720c8dfe538f53df9b15aca3b61809c70ecf502b566f2"
    sha256 cellar: :any,                 ventura:        "a2400a944b29cb80f349678138be4879a772313c3c54dc6f467f8fad30ac54b1"
    sha256 cellar: :any,                 monterey:       "c0c78d9cfee85691f6441eaa06f0962ef2220d0d0133561eb834890636a17f17"
    sha256 cellar: :any,                 big_sur:        "9998b2dcd6f3248a13e9b9a8d74c9efe66c45b7528d09867d5b24e144baba315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5279042fda36daaee45abd6bbe34b5eb675fe34a745755e8b1cae29b299830e3"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
