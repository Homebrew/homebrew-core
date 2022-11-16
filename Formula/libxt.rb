class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.2.1.tar.bz2"
  sha256 "679cc08f1646dbd27f5e48ffe8dd49406102937109130caab02ca32c083a3d60"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f18dc5ac2a79e09dee386201da716fdaeb04cdfc544287c5382bd399e1e99ba"
    sha256 cellar: :any,                 arm64_monterey: "7e817f2cb5cf9b4708246377c23745307d8cb7d0ee03d77b3a6e3b4fb16708ff"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd900ad5097946ee343ba7c15311a3b85540dcd058233e05f198c15405b9da0"
    sha256 cellar: :any,                 ventura:        "599e334d26186c677e16ce83c2cac7e116b5f0491b9d57e96e841192a50f487c"
    sha256 cellar: :any,                 monterey:       "f2dacb815eb7792b97b5e163bf6f8eef12b5d2283409322664ab937eb9954545"
    sha256 cellar: :any,                 big_sur:        "db76d4efdf96e00af7b4230245b81c26539b4ec20e93c1d379a3c92b39217885"
    sha256 cellar: :any,                 catalina:       "a1bcc92d37e1602ef760fecb79f7729db7e38aee2835879689596d478480217b"
    sha256 cellar: :any,                 mojave:         "4bd6052344cc12c674d40f44c31083264f5ce097ec0d2f6111e726862a8a2b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637ae200e0333076678621e5c5b330ca8ce5047534d5528f35bd7bfb59b3b630"
  end

  depends_on "pkg-config" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-appdefaultdir=#{etc}/X11/app-defaults
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
      #include "X11/IntrinsicP.h"
      #include "X11/CoreP.h"

      int main(int argc, char* argv[]) {
        CoreClassPart *range;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
