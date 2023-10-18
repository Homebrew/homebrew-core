class Libxkbfile < Formula
  desc "X.Org: XKB file handling routines"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxkbfile-1.1.2.tar.xz"
  sha256 "b8a3784fac420b201718047cfb6c2d5ee7e8b9481564c2667b4215f6616644b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da91cb89e6f63f01fecc0db527ec607b6c8693c4f2300c631b3f3bc3319a9c34"
    sha256 cellar: :any,                 arm64_ventura:  "e2cbf7af5949030dc34f0f5455a44bfef5e50c5afcbbdc1673bec74dd5b697d2"
    sha256 cellar: :any,                 arm64_monterey: "34962587b3ec814acd64923999bf674f967df17d496a94b1f6c8f7bb64fbfe93"
    sha256 cellar: :any,                 arm64_big_sur:  "fca001e0512c2d31aa35ab88e6982efce346f42b47a1e4dee9734862964d81ad"
    sha256 cellar: :any,                 sonoma:         "2c09803c5b89cb4303fbc178ca9cefba951ae07dc02be79381fdeb87bfea500e"
    sha256 cellar: :any,                 ventura:        "d53617fd18e769ab6d06447b823f7f81222240321ef17defcd0864cb46f350ef"
    sha256 cellar: :any,                 monterey:       "6aed9a4272cfe403b8ef41e3ec0bcaf8ef0554f5a48ca8ce1463a0e08bce215a"
    sha256 cellar: :any,                 big_sur:        "a6d7eb43abf1d93a421730d1bce87ee69bbda96ac5e178666601e17dba43b4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3166f0fa93d14f16172692130da99c9400601f46a831bd75ca7a9e7fd8d08ba9"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"

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
      #include <stdio.h>
      #include <X11/XKBlib.h>
      #include "X11/extensions/XKBfile.h"

      int main(int argc, char* argv[]) {
        XkbFileInfo info;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
