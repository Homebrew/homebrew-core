class Libxrender < Formula
  desc "X.Org: Library for the Render Extension to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXrender-0.9.13.tar.gz"
  sha256 "bf264b683d1e49ff9a6bc03af13baa430a556d943731a2b1ac2439dae4fea205"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98a4cdc34145658f8c4e5a27d78f985bab6c955485da21f5890f41bbd9ac56b8"
    sha256 cellar: :any, arm64_tahoe:       "cc2f74e28c8a822020f025403796b560f937e46bfdae46b83f5d4860aaec7cc7"
    sha256 cellar: :any, arm64_sequoia:     "d281b755455ee77f28bcf83c93501b525d7eb2c7a4b8eb8fdf640ee2c6e4b69b"
    sha256 cellar: :any, arm64_linux:       "508a77d6a5bcdf42e895364deecfff474d4fb64a700de9a8d84027944c798b4c"
    sha256 cellar: :any, x86_64_linux:      "248ebd6e734a951b0a3cf645b4a009abfa63c923c04fe3267a10f1c4765ef6e5"
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
