class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcursor-1.2.0.tar.bz2"
  sha256 "3ad3e9f8251094af6fe8cb4afcf63e28df504d46bfa5a5529db74a505d628782"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ffaf742cbe0cf49e80345942765c872093a222cf42ceaee7e139080883dc343b" => :big_sur
    sha256 "ddae5ae0c6cad51f281edd9908df4752a16ee6934a0e20f4d53e06b6e6cb07f3" => :arm64_big_sur
    sha256 "c8c48a2d78f7a5d23c1a1322ceac267d1d50ae8b7f1ad93c7a8b0e510afdf39e" => :catalina
    sha256 "fe9c7b74829d92a0330caa49aeaf03d52213f2d8671fe8a4840b2700fa1cb863" => :mojave
    sha256 "ac83b3e1c320f65c0dd7d66ef03abb3a5163ee8cb4b8932e14f008ae4cce5126" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

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
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
