class Libxmu < Formula
  desc "X.Org: X miscellaneous utility routines library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXmu-1.2.0.tar.xz"
  sha256 "072026fe305889538e5b0c5f9cbcd623d2c27d2b85dcd37ca369ab21590b6963"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ba17cb3b8b444f0a3a3c0f92519ed06bac658afde74cd50ceecc210456eef02"
    sha256 cellar: :any,                 arm64_ventura:  "218058f6254ce0cd76cdaaa77d6c7df6f05b92d309cff4a5ca8cd9c3210ac46e"
    sha256 cellar: :any,                 arm64_monterey: "625c73453fcfa7da721e824af226b745032fb5aa28a2bae209ae55ffa19a1ea8"
    sha256 cellar: :any,                 sonoma:         "4883cf0e39fe78bfe804b2b8f053307f62138971279b4080213df488e793fd73"
    sha256 cellar: :any,                 ventura:        "27e0cdecaf693e3f24aac76d866a7f6d365461738025696fa7c8dbea62dda66a"
    sha256 cellar: :any,                 monterey:       "0e25f2abb51dc909a4aa7090ffa493db1c780cc54e9536bc65b16a19aa9a0696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa0ade1134703890949dd3b027dbe6422f0b1d11cc943188f8815baa4b6eb51"
  end

  depends_on "pkg-config" => :build
  depends_on "libxext"
  depends_on "libxt"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/Xmu/Xmu.h"

      int main(int argc, char* argv[]) {
        XmuArea area;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXmu"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
