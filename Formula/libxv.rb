class Libxv < Formula
  desc "X.Org: X Video (Xv) extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXv-1.0.12.tar.xz"
  sha256 "aaf7fa09f689f7a2000fe493c0d64d1487a1210db154053e9e2336b860c63848"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4abc69ff5d7bc6589f2cad3bce5c1806663ae041f9baa37bd5e38dd614b3c798"
    sha256 cellar: :any,                 arm64_monterey: "13ab976fc89ac05fe51660801e55e30d8a98dcbb5bf0a037bf0a922bf9dc1aeb"
    sha256 cellar: :any,                 arm64_big_sur:  "3886235b3db42d980d1334efba2b4bc19c8e5112f33146e278ea8facd55cd18a"
    sha256 cellar: :any,                 ventura:        "de0cf22fe91fc6aef98d41c771e05e8e290b33f710f7b2d012a4de9292494e94"
    sha256 cellar: :any,                 monterey:       "aa57ca0e247ebd7af7cc9f19c1515c05385b29e08f0ffd353d43109be59e6054"
    sha256 cellar: :any,                 big_sur:        "4691aa977897287cf117d08f5ac69dccd9347c210774f601ea81c14b77d75374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db2f06d9ccdd30342fa9d7249dbc068cd1bdb3800f44e22424269f4c29dc5bd6"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xvlib.h"

      int main(int argc, char* argv[]) {
        XvEvent *event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
