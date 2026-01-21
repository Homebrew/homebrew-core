class Libxaw < Formula
  desc "X.Org: X Athena Widget Set"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXaw-1.0.16.tar.xz"
  sha256 "731d572b54c708f81e197a6afa8016918e2e06dfd3025e066ca642a5b8c39c8f"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4ecd7079a01f9f836d228420134c77a0c4948760ddc1dad19f816fe5ef6ae6f0"
    sha256 arm64_sequoia:  "fffcdd2fd7d440a43218e33fe5e4de0c4fca96641deb2c832abaca62b04e3b2f"
    sha256 arm64_sonoma:   "3682eac9ae16a794bcea9e0bb4b52a76caf44ca4894f93f1a5fcb2971cf83c04"
    sha256 arm64_ventura:  "822beca8cfc5df449c8c2616f41074357e5a10a9fe8d294912687cd2decd9094"
    sha256 arm64_monterey: "8575520c38a7b08e174384ec3ee3bbba96718ccd607065b92ae145cdc3b40251"
    sha256 sonoma:         "8500c636998ace11a0cf584ed9a45fc6c4ee5c505f04f2279c223a8214e4dfef"
    sha256 ventura:        "97953eebb88716cfbc585f5bd4cf80d299beca4aa19b62eaa1fdc1c43ea810b7"
    sha256 monterey:       "27c02e2745a3e97ddf364ca4a41191a65ea63a038f1c971a3c367b1a7b2d6c17"
    sha256 arm64_linux:    "6819d4477ad52c23eb7023c0679d339adf59b43852cc05ef74f4a40f91a4d423"
    sha256 x86_64_linux:   "b848eb55c4b41ebc2923e5f0dd8a3fcd0fcf7ec6700347f6469ff88b958857da"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  # Backport fix for improved linking on macOS
  patch do
    on_macos do
      url "https://gitlab.freedesktop.org/xorg/lib/libxaw/-/commit/cce2abf00fa2c9a695f1d0e5c931c70c1ba579cf.diff"
      sha256 "64bfebc3fcb788582abbf2589514e64b3fa62457089c77e644177f1c0a80c10f"
    end
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-specs
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xaw/Text.h"

      int main(int argc, char* argv[]) {
        XawTextScrollMode mode;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
