class Libxres < Formula
  desc "X.Org: X-Resource extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXres-1.2.2.tar.gz"
  sha256 "8abce597ced4a7ab89032aee91f6f784d9960adc772b2b59f17e515cd4127950"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9bc0c9dc2360187c4a20cba5cff03e7a984c87ba8385f1c90dd0f4e3cab3148"
    sha256 cellar: :any,                 arm64_monterey: "08be16e63de32143d6e1d506c17b0bf9967ebf339559ddd4086e3da5e065d900"
    sha256 cellar: :any,                 arm64_big_sur:  "60935c75823a1601c976f1bcd0ac3376bf61b3a5662722c2490da69f7f69ba91"
    sha256 cellar: :any,                 ventura:        "3eb0829bc11d328efedab19036ff7e4e147b887513d00a83a80c8c3037360408"
    sha256 cellar: :any,                 monterey:       "95854ac6d283e212a643ed836fcc24c21e4ae78a6c0d8ed251ed9090f7e3a613"
    sha256 cellar: :any,                 big_sur:        "993e7994f092301118aec29874cd7332ac5ddf2199dc38784f46aa2650bf54ff"
    sha256 cellar: :any,                 catalina:       "98b7edc1c10775aa7fb949cb1cdc8e2a33a6f4a9de16b7e7d9366f3cd7ecdbeb"
    sha256 cellar: :any,                 mojave:         "147c8a30297594a8da02cf5b46942d2c1408683adde5a7abe8ec272ff0452ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0819e6b6456495c3fc61d885f2f07385fac6dcce43c1d78f81fb7c8ee91fa418"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/XRes.h"

      int main(int argc, char* argv[]) {
        XResType client;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXRes"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
