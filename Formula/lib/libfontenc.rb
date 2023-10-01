class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.7.tar.xz"
  sha256 "c0d36991faee06551ddbaf5d99266e97becdc05edfae87a833c3ff7bf73cfec2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0501017908eb93287f64d457049e26e6b69211799e25f3a69e4fe2d6e6a007db"
    sha256 cellar: :any,                 arm64_ventura:  "89c55c64b24c173e1b1077204a81c7c6f7fd63f9639a832fe579b003d8724189"
    sha256 cellar: :any,                 arm64_monterey: "bde5e3dd6ad10d8e6230ea00c6c485c6d17ade06658497fd3991b843392c355a"
    sha256 cellar: :any,                 arm64_big_sur:  "64a31afac76ef33361e82421097bd29442c15d00ce4059022c55c175bba54851"
    sha256 cellar: :any,                 sonoma:         "7f38d4b02485fb8d72585baf407492534f752e03a10ac5271dac564bb6ca2c38"
    sha256 cellar: :any,                 ventura:        "85c21c23c0538c7fed8d9591b6fc4e6d7b33c90060f634c71f36706faeb6d9aa"
    sha256 cellar: :any,                 monterey:       "cfcc68d02847b7bc5e589e879e80b0f75d35902eed69d589fb1f1f845788726a"
    sha256 cellar: :any,                 big_sur:        "5cb685676aa5eecac810649fdac4ef1e2d9a775498590e834d3c7797cc3df377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62cbc3809dd3f189c3f55b42d3b044a2786b6a8f03ba5b3f3e766997b1b739e"
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
