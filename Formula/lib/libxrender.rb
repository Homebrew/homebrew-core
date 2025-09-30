class Libxrender < Formula
  desc "X.Org: Library for the Render Extension to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrender-0.9.12.tar.gz"
  sha256 "0fff64125819c02d1102b6236f3d7d861a07b5216d8eea336c3811d31494ecf7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6405639931b8924b009e16163b7d99f50a10274189cb7f7eba12a4585d1ef255"
    sha256 cellar: :any,                 arm64_sequoia: "edcb8884f9d33219d276051be3b5ad64f390cdf3abe9794d9a0050c02895c3a7"
    sha256 cellar: :any,                 arm64_sonoma:  "a9e072e66b91797a41879d60271ac73a0b6a6e487a80ca054a44c209352e20ae"
    sha256 cellar: :any,                 arm64_ventura: "0d5c91bc0d13b447077fadd8a7b73e1b65091db9d03e5f6f515eb506591c8bec"
    sha256 cellar: :any,                 sonoma:        "97554360bb9c9e82ebc7140f0186f02c103e877988c1d4a0139fbd5be1990f6a"
    sha256 cellar: :any,                 ventura:       "7738d05da7567ca24736fc6ea5a4f881a0cd33ebbbb023d647844e183b785e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6370f22ed262b6bbf0ce75fc0993b26b4b0fa7a332e02ac21586ebe11c5ecb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44bddde0557643e137ddd5aa00d60bf220527719d2cb9263e397098dee2664c5"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrender.h"

      int main(int argc, char* argv[]) {
        XRenderColor color;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
