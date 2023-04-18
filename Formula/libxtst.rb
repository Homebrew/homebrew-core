class Libxtst < Formula
  desc "X.Org: Client API for the XTEST & RECORD extensions"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXtst-1.2.4.tar.gz"
  sha256 "01366506aeb033f6dffca5326af85f670746b0cabbfd092aabefb046cf48c445"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "64703f879e6130e99a850a56567fc1a9de0024a0ed276a6eefa5768852c9870e"
    sha256 cellar: :any,                 arm64_monterey: "3b8d22abd476602cb2892a68c31054a696e760aae1912dee00c08abaff710922"
    sha256 cellar: :any,                 arm64_big_sur:  "41a2b4709a78d3b00dec19b298dc5551fe1eb2c530556c8daa75ef2f74527ed6"
    sha256 cellar: :any,                 ventura:        "e9aa2923a5647444b5557ae761abdc05730c5c0bd836103853921ef9df38d4dc"
    sha256 cellar: :any,                 monterey:       "4ff71b57fb57f02df2b01623684174c826203969bbbf49d9ac77c6f94b60f23c"
    sha256 cellar: :any,                 big_sur:        "761a44edff4b064f0019e663d8cdd58753ad40910a6bd4fcea6c5e8f946ab3bf"
    sha256 cellar: :any,                 catalina:       "4b7e04a2af86298d776f8a06da28a466a38f22aa4e24299b357ef7d0e11ec53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed487372cd98ae495904e2c0c9b2fcc96cc6d080f0a13be344a37d99849af35"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libxi"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/extensions/record.h"

      int main(int argc, char* argv[]) {
        XRecordRange8 *range;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
