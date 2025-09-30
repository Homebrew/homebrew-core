class Libxv < Formula
  desc "X.Org: X Video (Xv) extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXv-1.0.13.tar.xz"
  sha256 "7d34910958e1c1f8d193d828fea1b7da192297280a35437af0692f003ba03755"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7666bec93f718a4de65c627ec6dd4994d6e0e983f97128665d44f28af23fc76"
    sha256 cellar: :any,                 arm64_sequoia: "ca4ceb63d5715291d60b70df4374fc26c5d559fa3e97fd7cd910df33f5a0a4b0"
    sha256 cellar: :any,                 arm64_sonoma:  "b5b7f229fbcefcabbeb5a0bbac23094686d2669c1adebfd5c292bc57528442aa"
    sha256 cellar: :any,                 arm64_ventura: "feb734a5af4fb26c75394824bcb0e3475eccc29432c3737ab89433a9b8980b5d"
    sha256 cellar: :any,                 sonoma:        "efca4bea336f2d0ccf72c4b70d7fe7b651ba28ded3c751d83dc9c612a0baa348"
    sha256 cellar: :any,                 ventura:       "a84ae702322ad41c4f4700a86f0c433211b2ecea8e5d491924cb11e3d6021027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb1cd4b0e4cc2810b08615670b5881ec52067350a85e40d54e0a0c01b8450e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1371d2c06b2dbb27c1e2c3e7e15227a9741dcf2a6709513e0577d185628291f"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"
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
      #include "X11/extensions/Xvlib.h"

      int main(int argc, char* argv[]) {
        XvEvent *event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
