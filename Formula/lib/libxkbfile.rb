class Libxkbfile < Formula
  desc "X.Org: XKB file handling routines"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxkbfile-1.2.0.tar.xz"
  sha256 "7f71884e5faf56fb0e823f3848599cf9b5a9afce51c90982baeb64f635233ebf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d232816434655702f1c58d0d1039355d200d8285ebcc02b0680942b4747f4015"
    sha256 cellar: :any, arm64_sequoia: "30c6f2323590d8bdeed7bdac55b00f1f9de960ec490d2421cb6789277f375462"
    sha256 cellar: :any, arm64_sonoma:  "9937dda8394a342f512b09d64194d346da94495bccd947b2410ade55ba01d359"
    sha256 cellar: :any, sonoma:        "d8ef47a92bf49fa2bc0e6e9716b8ffea0bb76d658492a6c9f4ec915780a2b8d6"
    sha256               arm64_linux:   "f6b64ee60afd0f86b821e1d61d6d8dedfb1f36feca8c95fcfb2f93745c494b57"
    sha256               x86_64_linux:  "72f1360f77a0daced0f3259762db1cc220369f8d7913af25246d8ddee7ef9d8d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <X11/XKBlib.h>
      #include "X11/extensions/XKBfile.h"

      int main(int argc, char* argv[]) {
        XkbFileInfo info;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
