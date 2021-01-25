class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libfontenc-1.1.4.tar.bz2"
  sha256 "2cfcce810ddd48f2e5dc658d28c1808e86dcf303eaff16728b9aa3dbc0092079"
  license "MIT"

  bottle do
    cellar :any
    sha256 "05f64e556ed6c0576407b084aba036ff0fed95f831778ad8b6363b4fe6f0836e" => :big_sur
    sha256 "113e1edd38c2ae3c0ca865e3ac90a7bb81e232855513fa598d08514fffde02cb" => :arm64_big_sur
    sha256 "b57f18c5d875f7ceded9115cd1971be92a3c3887c7c606ff5028ea1ddb160b1c" => :catalina
    sha256 "e79ca92c5f40a57da0b5745df2eb64fe532e90bbf292e4d97a4703d5b0e15791" => :mojave
    sha256 "83bf803c71ed38edf5204ee3bdd89f6569c4c04a41c64003f20ab67b7021f2f2" => :high_sierra
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  uses_from_macos "zlib"

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
