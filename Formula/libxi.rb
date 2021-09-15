class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.7.10.tar.bz2"
  sha256 "36a30d8f6383a72e7ce060298b4b181fd298bc3a135c8e201b7ca847f5f81061"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "59e52427d65052b2a30b59cacb165118f828b03922fe3ac99490701fc4374f02"
    sha256 cellar: :any,                 big_sur:       "ef121c80170a695096e8505424820959c31a757659d282507b3933ab109a6a96"
    sha256 cellar: :any,                 catalina:      "a0fddd9dcb30077a6a2736540bf2d1cee8bf44fb8291d8b6ad1207086bf6f63e"
    sha256 cellar: :any,                 mojave:        "c6745a3e9274dd78e9c4372ebca168ca1ae83600fd5c5ac68a59cc4dc60f3d6a"
    sha256 cellar: :any,                 high_sierra:   "641cd78fbe4d389ce51c071deb60b62da482aa623e49bf0fe1b765b67d1380ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a21d9cf9f87e8f518cbc539969c0e643054ae67e8c315be2d47bc36ab4d4d3"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
