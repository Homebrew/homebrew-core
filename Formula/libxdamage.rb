class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.6.tar.xz"
  sha256 "52733c1f5262fca35f64e7d5060c6fcd81a880ba8e1e65c9621cf0727afb5d11"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7ba5d6474c6d7be855f270e843c42d1e3b819d43e7d96c3b62789265f264a3b"
    sha256 cellar: :any,                 arm64_monterey: "1b820498fc3f7216bcf074f0c8165875a0250390e837d9db05a62bb9ada85d5b"
    sha256 cellar: :any,                 arm64_big_sur:  "e80bbc3be1914e6a890f446dca34b789b0c0746bb0bf78426bd8d3137b771f13"
    sha256 cellar: :any,                 ventura:        "0a57b493cab139a05dfd0d497b01a98525161094a456568fe35175043bd5f792"
    sha256 cellar: :any,                 monterey:       "f4a6249de91d6f556fe83f4d092233a7b45dff9fe2a3dcf7c23f43e8cb502b9a"
    sha256 cellar: :any,                 big_sur:        "682e7654ca8a9c91c37b156e173f2280fef06e51ba6604062a8fc3966ef01028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d888f5feb3f6cbaf35ca9d4f6af015555e30be8295bb378594290081e74c29f"
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
