class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.4.tar.bz2"
  sha256 "59ad6fcce98deaecc14d39a672cf218ca37aba617c9a0f691cac3bcd28edf82b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e09ff59ff55eefc431207d0d6a78d6f098bb07e5a13be1dae3b0514979173b8"
    sha256 cellar: :any,                 arm64_big_sur:  "24e44ef107138f015271fcd5aaa400403594adf7c64cf4a628b0cfe44d4e9fc6"
    sha256 cellar: :any,                 monterey:       "04101a93002bbd6249ef45d48ff2647d315614a9c0685fcbf3e59e95e80ba5b8"
    sha256 cellar: :any,                 big_sur:        "8a037408ba5c4c95c33af0d022edd631b744823bb9fa522a06b502ed9bf1fbc5"
    sha256 cellar: :any,                 catalina:       "20cc49734eba43e2e9f058fa12f3782c76ac232fada3f6d297f91dca6e0582be"
    sha256 cellar: :any,                 mojave:         "3f2da07d877e158f41231d088f0ffe5551132beaf2f3df683dae0ac2c11817cb"
    sha256 cellar: :any,                 high_sierra:    "0070b8ea70006d011aac1c617e1a5f88caa2ae351b637858f828f859cb72d813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7d5b80cf1ac00d0ffff27be679d38c0b7c8e8ee8ceb1747bb1f8ac9e5773d0"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
