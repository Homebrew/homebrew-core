class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXcursor-1.2.3.tar.xz"
  sha256 "fde9402dd4cfe79da71e2d96bb980afc5e6ff4f8a7d74c159e1966afb2b2c2c0"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "2c4a7bc7940a286ecb8a6fb90a3380ea01da85468856f50279555c6b14926540"
    sha256 arm64_tahoe:       "0ce9a15234d8fed400468ba6071d6d6d981e7e64fdc4d6f492fa95fa78ee4f27"
    sha256 arm64_sequoia:     "89433fda42917b2845ab4b45f70a307ea34dcc030d8f19ee9269e60db8dedb12"
    sha256 arm64_linux:       "de8516c4f3994809d0a7a2fce41f2089b2f84d7831e0f970d3aca4052b67999f"
    sha256 x86_64_linux:      "b0e43878cc57b710c0ae5d839b09614534f52d7bce60e5a5de9ea721f4c26fc6"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

  deny_network_access!

  def install
    args = %W[
      --datadir=#{HOMEBREW_PREFIX}/share
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Workaround to allow brew to record binary_relocation_files as directory needs to exist
    (share/"icons").mkpath
    touch share/"icons/.keepme.#{name}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
