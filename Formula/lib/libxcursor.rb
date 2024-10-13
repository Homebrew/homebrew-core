class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcursor-1.2.2.tar.xz"
  sha256 "53d071bd2cc56e517a30998d5e685c8a74556ddada43c6985d14da9a023a88ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e9f543907a8a1f887857c96890146464bb3a99e41f3eadb1270e6ee381d02554"
    sha256 cellar: :any,                 arm64_sonoma:   "315d7f2482fc10ff82ce990f9b3bce98a81fbe273e10e0a8d89bfe7cd79afe77"
    sha256 cellar: :any,                 arm64_ventura:  "0716d39d1e8ec92ce9bab7477ccb2cb6caea6cb66d8633f6ccfce8b056b9b3c9"
    sha256 cellar: :any,                 arm64_monterey: "00ac4f325ce5028dcfcf1c6ba9c8126b4b8468b2cf3b86a4dadccc3585843905"
    sha256 cellar: :any,                 sonoma:         "77f69443f9338aea09d339c47e12f5f0f6c13228047835147d92437622508206"
    sha256 cellar: :any,                 ventura:        "be47ccbdc21395feffc509856adcd19a562bef8bd6f748767f4d0bb8da5a038e"
    sha256 cellar: :any,                 monterey:       "5c9b0de207abaadf9fca789183a53a2c1ec769a1781e143b5e22ce0dbbc62ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2641509f3eb5debb4fb842c85b02ef78b67494dd50b8d47955f7cdcfac65c277"
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
