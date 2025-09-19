class Libxtst < Formula
  desc "X.Org: Client API for the XTEST & RECORD extensions"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXtst-1.2.5.tar.gz"
  sha256 "244ba6e1c5ffa44f1ba251affdfa984d55d99c94bb925a342657e5e7aaf6d39c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3695416abec8f1da23fddcc232bdc5e9522f822f67c7a0c69f522f54c8653617"
    sha256 cellar: :any,                 arm64_sequoia:  "28d4af1505473aed939328ace91056e111623d0c60b817d0b98dc3e00472dc4d"
    sha256 cellar: :any,                 arm64_sonoma:   "aaefda085ce2cd52a2fccada770bc3280c75128ecbd66f92ea7afa25c11631c8"
    sha256 cellar: :any,                 arm64_ventura:  "ee96653ea151d173c107e01ef1945ddca27e4585dc89c1eab34e7dd70a5718fa"
    sha256 cellar: :any,                 arm64_monterey: "618320ced081879132c2a569a2e8843326628423bcc8b1fbca86a0de66cbdc11"
    sha256 cellar: :any,                 sonoma:         "fac9520eabdd31b4defc300ec39c860da9809c8850415b2c8ba799e1849e5f2f"
    sha256 cellar: :any,                 ventura:        "1b29a72e003a2f5b3ea2bf308ed8be1218146051fa941177a1eca49099558362"
    sha256 cellar: :any,                 monterey:       "252a0ae6686b4d4f5098360cb7ed9a2f25d8dd122ae79150af3533509da1e102"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "270e406f0aa8cdbd35a39c76ebaea72a79325ac23ee3342d1cc5f7c930a8f337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cacd4573d0d4e1cc33c83574cf4838d93de28276a9cd3c69496da8a4466771"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/extensions/record.h"

      int main(int argc, char* argv[]) {
        XRecordRange8 *range;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
