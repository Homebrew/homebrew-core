class Libxtst < Formula
  desc "X.Org: Client API for the XTEST & RECORD extensions"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXtst-1.2.3.tar.bz2"
  sha256 "4655498a1b8e844e3d6f21f3b2c4e2b571effb5fd83199d428a6ba7ea4bf5204"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4016038d2adf6715b9aa399ca044304035f4bccf88448e1ae7555b6ad202e866"
    sha256 cellar: :any,                 arm64_big_sur:  "95bac4f4d192887e3cd974a7b78fa7dd7259ba5fd7cd40adbbb9994dd6dd3c6a"
    sha256 cellar: :any,                 monterey:       "934f99ee58a09de686cc63e835f63ab16d7cfc97808074a9f6af922da79231e9"
    sha256 cellar: :any,                 big_sur:        "d7d1a150cd828c40a1931f52c1da747b702ad09967e9039582cc6689615f6124"
    sha256 cellar: :any,                 catalina:       "f92434b774fd9e3907c2cd1c1da713ac5d96b1b1f849499ac6e9de931ea351c2"
    sha256 cellar: :any,                 mojave:         "ab324bbaded049ed3c6aa72eb768df8d6c20e1c98be3d56f9568ed56be5a9c26"
    sha256 cellar: :any,                 high_sierra:    "e8d0a57e80cd57e9dbb1034bbcac52ca03812a627cd42e086f73db077ce707e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81dadd1477613a046eca000b17f6c12850ca15769cb8556fff01b4c6d873379c"
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
