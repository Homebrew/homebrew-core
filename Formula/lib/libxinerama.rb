class Libxinerama < Formula
  desc "X.Org: API for Xinerama extension to X11 Protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXinerama-1.1.6.tar.xz"
  sha256 "d00fc1599c303dc5cbc122b8068bdc7405d6fcb19060f4597fc51bd3a8be51d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1661f76115723be21049a852556fe270ce1f53693beab0931ffa88b40b757129"
    sha256 cellar: :any,                 arm64_sequoia: "4a9b6fb1bb70ae6b4005e94c9d5737077e98f9ac2e5fbfe011371a6e5187006d"
    sha256 cellar: :any,                 arm64_sonoma:  "47157ee5e1d5e8083a68e1f696270dce2ea63d4efae579b2ac3a2cf4bdef2fde"
    sha256 cellar: :any,                 sonoma:        "1a447fd892652cccfda6f323ebc191d8855532a381381e2c2b05358f1f0bbea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68ea21d37025e719630cfd403bfdc5f43e5458c4f0305d71c510ba17ebf3d858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52991cf289d5e90078916a2e43d188e4f3fcbef3eaa83ba3a6a911715b17a1fa"
  end

  depends_on "pkgconf" => :build
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
      #include "X11/extensions/Xinerama.h"

      int main(int argc, char* argv[]) {
        XineramaScreenInfo info;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
