class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.3.0.tar.xz"
  sha256 "52820b3cdb827d08dc90bdfd1b0022a3ad8919b57a39808b12591973b331bf91"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9de6f181593f1f0be6a7cec1a999f747dbb0f7f5bab504a9c37aa58efa1b07ab"
    sha256 cellar: :any,                 arm64_sonoma:   "08246691bf368897e4bcc80389962df8ffc1c6ec6c194f4731c754cfc275995b"
    sha256 cellar: :any,                 arm64_ventura:  "48ca6ecece618b42eb2807955ceefa5f1e9f6f1ca4a3b9eff5962e4d1ae5a123"
    sha256 cellar: :any,                 arm64_monterey: "eb7206d9e14872a778762922a39a59d06bdd5c8055474d573ad7f9c0976c6547"
    sha256 cellar: :any,                 sonoma:         "784abc72bbb694244ba1f7cbfee0f5ecdc084c9d1ef41557c68fe06e6f4a17a4"
    sha256 cellar: :any,                 ventura:        "e4a31758e6eba0e10e563977c680fa99a22eb80956a67f438851e7ba4996e3e1"
    sha256 cellar: :any,                 monterey:       "5b492610e7277b9d9f80e03551db7ed45886cf362a2a399bf67f43344efb00b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "505a098f0763f672253f047c75408e739da9956def530758db3476e21184b157"
  end

  depends_on "pkg-config" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  # Apply MacPorts patch to improve linking with widget libraries on macOS.
  # Remove on the next release as patch was upstreamed, but commit doesn't apply cleanly.
  # Ref: https://gitlab.freedesktop.org/xorg/lib/libxt/-/commit/cbbe13a9e0fd5908288e617b56f41ca1a66d9a0e
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/37520eaf725382f025ea4ce636e4c30fc96bc48d/x11/xorg-libXt/files/patch-src-vendor.diff"
      sha256 "93e806b5ba3fce793591d6521634553a28fd207e687366aac3ab055fbe316c55"
    end
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-appdefaultdir=#{etc}/X11/app-defaults
      --disable-silent-rules
      --disable-specs
    ]

    system "./configure", *args, *std_configure_args
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
