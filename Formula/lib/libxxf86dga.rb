class Libxxf86dga < Formula
  desc "X.Org: XFree86-DGA X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86dga-1.1.6.tar.xz"
  sha256 "be44427579808fe3a217d59f51cae756a26913eb6e4c8738ccab65ff56d7980f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cd3ed49943a02c8a1d981be08e12fa69322544eaf4f312defcfd5f630a554785"
    sha256 cellar: :any,                 arm64_sequoia:  "eb23f74c86d0455fea55619165dc67a91596a64f46e2b1575941612eb763319c"
    sha256 cellar: :any,                 arm64_sonoma:   "aabd31abe4a5de30d5c7e5597d1375c90620aacfc65e29973ef08afc2a8cea15"
    sha256 cellar: :any,                 arm64_ventura:  "d28beaab68c473b46d08570b3a351f50ab6c303187383c3cac0342f9d7cf2d56"
    sha256 cellar: :any,                 arm64_monterey: "e9e16c678779cbe12b944e70b64ab466e16ed037e93baf26d50f6132834135e1"
    sha256 cellar: :any,                 arm64_big_sur:  "44a81603b3df546c0af4c81359ed676f160fee8a6653189616945c70fe680f8f"
    sha256 cellar: :any,                 sonoma:         "1268406d3219140025e3ecec8b1897fba05230fe0e2331f16ca2f028fc92182f"
    sha256 cellar: :any,                 ventura:        "0b31da893a8d2b2f88925e2d433252bfc712e2777916dc34e3c1c11be7b6e8b1"
    sha256 cellar: :any,                 monterey:       "b1248f35772649eed2823a6a37bacfc1d2a860c9c5187ceafae9dedd511db70a"
    sha256 cellar: :any,                 big_sur:        "e5cbd5be1621338c7040d39bc3b7e3a8296d0171e747372e3d3b0b1f1747081c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b559dfe88d4ae3895c798f0de94f418fede30bb5a114c5cf6f0074efd1373c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80432c3b9c22e33647c255fc8669b182d3980df952d6e5f7f1c93e6d31b56285"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/extensions/Xxf86dga.h"

      int main(int argc, char* argv[]) {
        XDGAEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
