class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXi-1.8.4.tar.xz"
  sha256 "ddd6057b89a91903bc2f884d55c8467440906945e482c36547260dff28661afc"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c4ea7477a16ffb5c74162f30ee428b6dad8548fecf6393a07f702a787af307b4"
    sha256 cellar: :any, arm64_tahoe:       "7a70e3f2cfb5d61ac4c02cb9370945bad39302964df7c48ccca8f4ea794483a1"
    sha256 cellar: :any, arm64_sequoia:     "e4baaa8a0d044d9b85a9df2705e0c6ae53478c5f5a2a96d5b9de46794b721443"
    sha256 cellar: :any, arm64_linux:       "0681a48da50c14074169f0ce53e19b115d4eab1cf94ae55aa883c8ce48200d76"
    sha256 cellar: :any, x86_64_linux:      "74fd528e3d852db335c4d8de289cdec8dd907432ba052eeab4a6ab348f1cf55a"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
