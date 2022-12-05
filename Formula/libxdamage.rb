class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.6.tar.xz"
  sha256 "52733c1f5262fca35f64e7d5060c6fcd81a880ba8e1e65c9621cf0727afb5d11"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6d6b8f9afcd3746a9d0da10592b154474817d5740ecd514fce6568fcfde672c"
    sha256 cellar: :any,                 arm64_monterey: "eeefeeb565b76ee3e2439d2eb4341e02f36b5ce4d9aae5dc150f7f1489c8fd73"
    sha256 cellar: :any,                 arm64_big_sur:  "bbd5ef8f7408de369198e66bc6aa8a75ddc798c444ebd7f03b885bc25ccfb136"
    sha256 cellar: :any,                 ventura:        "79bf762bdf9ac37319a7d0ac0e343c4664681b19b6a8f7366c0edbb411622438"
    sha256 cellar: :any,                 monterey:       "e6b04a9a43aea7fa0e047ee721d78cbaf9985ff1f8e7b62b9d0645bbccc88746"
    sha256 cellar: :any,                 big_sur:        "68750157664e1290e30b15ad95dbfcc1be2748b85e7eaef0851f2c0f56f043e3"
    sha256 cellar: :any,                 catalina:       "2c09f29dfafe280bc0179dfe6ad82b623459e6bec07fefac41cf6b3e52385100"
    sha256 cellar: :any,                 mojave:         "ea0aee131addc90c4b4ba6e0d8c4f8cdfd39dc034a7bfc3e841c408042ad8906"
    sha256 cellar: :any,                 high_sierra:    "5c0ca5debb8c99cfed432fa2299e4a280ca81f8988aaacf44e0c0194d89ca7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b55a0d21cbb4d4ad796564955f10369d59d80e7ba156c95cce2f82486cfcdf7"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxfixes"
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
      #include "X11/extensions/Xdamage.h"

      int main(int argc, char* argv[]) {
        XDamageNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
