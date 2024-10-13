class Libice < Formula
  desc "X.Org: Inter-Client Exchange Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libICE-1.1.1.tar.xz"
  sha256 "03e77afaf72942c7ac02ccebb19034e6e20f456dcf8dddadfeb572aa5ad3e451"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "72719037ab14a8bd8f4acb21d4c2a4562df939621cd115f4eeb9c0fa8a62dbd4"
    sha256 cellar: :any,                 arm64_sonoma:   "9631199b732614ee51c17bb28c12cac73da2317a4496da042900ef3d80f73b17"
    sha256 cellar: :any,                 arm64_ventura:  "4b76f982119e65321f62bbb740a549d08f280ab7055496210ac78acf6505a6c4"
    sha256 cellar: :any,                 arm64_monterey: "2b30372decf9b63bb1c02d6dabe2eb8216eefd7abbb71e902863ceac1633dcaa"
    sha256 cellar: :any,                 arm64_big_sur:  "34577a485f10e25e38e27606158bd082e460a36874532bbc0e720bd71f5b9db8"
    sha256 cellar: :any,                 sonoma:         "3361ef875d4db4f7d0f98d3880c61e38648f207c7010881dadaef6c9dd68f852"
    sha256 cellar: :any,                 ventura:        "be08a5e12f40f1f2e5fc780ca8735969a41b5f2f5d5994788721de92120828bd"
    sha256 cellar: :any,                 monterey:       "a6c573ba977c781d5d6c8a5a361ed109b7bdb94f8ba0907a0ff4fc69cd425baa"
    sha256 cellar: :any,                 big_sur:        "041d92a0fbdd7f581ac42bf05d63ff8156c52d5ce6218b92aa0929d221ece18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed9bb2a55522c29d05b499b235181e2474d34e242991238e8322b3d8222ecb7"
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libx11"=> :test
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/ICE/ICEutil.h"

      int main(int argc, char* argv[]) {
        IceAuthFileEntry entry;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
