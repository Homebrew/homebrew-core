class Libxshmfence < Formula
  desc "X.Org: Shared memory 'SyncFence' synchronization primitive"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxshmfence-1.3.tar.bz2"
  sha256 "b884300d26a14961a076fbebc762a39831cb75f92bed5ccf9836345b459220c7"
  license "MIT"

  bottle do
    cellar :any
    sha256 "89043d871005cac00e19ea895e9a30046296d0bd14edc0cd879328e53b3750a0" => :big_sur
    sha256 "2651a6db4ef81559e17f4bb1e4ab5bbe246f54ec3cdce1f69ff9032f36789c36" => :arm64_big_sur
    sha256 "b6edc10c83f07c28fdece7c98b9be2e7c85518b0357311874c5bd5cca1217922" => :catalina
    sha256 "9ba60796d9101ebe5fe01d5fcbbc7f685fa8619fc0ba51004b0fd68488af47c4" => :mojave
    sha256 "ed7509cbecb38ec5fb75ae80de12248c8d25b931cbaff12f94f3566d05b77238" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => [:build, :test]

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
      #include "X11/xshmfence.h"

      int main(int argc, char* argv[]) {
        struct xshmfence *fence;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
