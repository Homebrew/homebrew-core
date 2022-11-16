class Libxaw < Formula
  desc "X.Org: X Athena Widget Set"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXaw-1.0.14.tar.bz2"
  sha256 "76aef98ea3df92615faec28004b5ce4e5c6855e716fa16de40c32030722a6f8e"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "40d7d5b525718007f166603a9bd8e166c405a50e888c0014eb3ebb0982f42372"
    sha256 arm64_monterey: "7f72cb216e6754e6f72bfd0e0f03f19d4599e69b4562980f274a3797068194c2"
    sha256 arm64_big_sur:  "6f9bd6bef10340da3fc23f24d0c4a4e3358dcbada118a8b74c4e05d901ac0dd6"
    sha256 ventura:        "72e46b226ca150f64dd4d6c6faf1602b94693d917ff500757c446afd352f8495"
    sha256 monterey:       "016221c5b49049daa3743b4957bb0f128b0f0f1e71037f27daa054364d8209af"
    sha256 big_sur:        "bceab125f7dc2fde90b23c68daf8d3a6b5fff65a0f3f3895abe750a74a328dc6"
    sha256 catalina:       "345ff906f7375ae71a550298fd482c849994ed25d0263822fe7ce8f3740db9f2"
    sha256 mojave:         "16cd8aec41f9df9798704213ac41b7e9013d1a8af9f4bda90bfb13d50e55f057"
    sha256 x86_64_linux:   "fa7c50e5fd51af0f69ee8d2369e390b7961194f227d5d09c2fcb91691f54f54c"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

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
      #include "X11/Xaw/Text.h"

      int main(int argc, char* argv[]) {
        XawTextScrollMode mode;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
