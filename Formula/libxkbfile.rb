class Libxkbfile < Formula
  desc "X.Org: XKB file handling routines"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxkbfile-1.1.1.tar.gz"
  sha256 "87faee6d4873c5631e8bb53e85134084b862185da682de8617f08ca18d82e216"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d168e608eb86d667cb38159b7a1d8a7075dc2a27452ddd01a79e98f774768373"
    sha256 cellar: :any,                 arm64_monterey: "ee43a751acb1d2368c2002d81b87c71c4729a34aa95c18540071cd1b2eaf1f8b"
    sha256 cellar: :any,                 arm64_big_sur:  "e33a381dd6b30b86920adbbd64c48e18e2cc549bcab25a6c8f40c72705fd8fc2"
    sha256 cellar: :any,                 ventura:        "662adb077f1619cb46c95aac21cc79bfa34c2334a12998de7a1f5ebe6302565e"
    sha256 cellar: :any,                 monterey:       "4d0447b062d2b7a25314138c27c7541101d494ee3ea366905bcbbe1265cdadb5"
    sha256 cellar: :any,                 big_sur:        "d03791354356b615e28d6764beb46ec25eb02b5400f9ab44afc9344886997f03"
    sha256 cellar: :any,                 catalina:       "f9ee4cdf0be6c785c3a1eef84490cfb3f9caabb0f838d38a3369c2493fed825c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e9fc16f4f7a6c9b2f5457fd231e5c7ad89ebaab966daa83b21fecfa2be3896"
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
