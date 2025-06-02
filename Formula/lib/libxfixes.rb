class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-6.0.1.tar.xz"
  sha256 "b695f93cd2499421ab02d22744458e650ccc88c1d4c8130d60200213abc02d58"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d8cf5f8d0134815b458eeaf44dd0e18357322bfeba750b4a79c7619ce24568a8"
    sha256 cellar: :any,                 arm64_sonoma:   "50d2927a1b3705cccad6057873681f1605786646c2dbd8af9bac2dcfbd1b49d6"
    sha256 cellar: :any,                 arm64_ventura:  "b087b60e125d6e348292f14f9d692693a0dca7894975002fa29f754c25395bbc"
    sha256 cellar: :any,                 arm64_monterey: "515bbc38f06c142ff7cdb65b9f1401fe187241b64186b0670f4809787e288c2a"
    sha256 cellar: :any,                 arm64_big_sur:  "5f5221e3a5687ea308dd4e0200617cbba63289476df92e6addc3928597033c3b"
    sha256 cellar: :any,                 sonoma:         "883bed610e677c56484e31d6a1f79f06693927f004f94e01cc24a83b49df41be"
    sha256 cellar: :any,                 ventura:        "ade02ac4b73db0272d8bdb95bd05f8c8c11683daa944c66a10f1e72740bac364"
    sha256 cellar: :any,                 monterey:       "bae672517d9d8a3af7481ecb71dc13d835231b51917b6848d069550a725a09f9"
    sha256 cellar: :any,                 big_sur:        "5fb3942149518881721a07646cb045b3dd0478e6333617409d3cf25a8254740e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4d72cccea52617216275c3aecbe6fa1435673735507bf7e8f61f2f9ab6f454d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd98561e1f625057b34be07c81541d7759f29756d5d7272b59bd9e86af0d7d22"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
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
      #include "X11/extensions/Xfixes.h"

      int main(int argc, char* argv[]) {
        XFixesSelectionNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
