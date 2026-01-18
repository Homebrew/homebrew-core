class Libice < Formula
  desc "X.Org: Inter-Client Exchange Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libICE-1.1.2.tar.xz"
  sha256 "974e4ed414225eb3c716985df9709f4da8d22a67a2890066bc6dfc89ad298625"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c7fe005691e3b774bd67fd52e5a16bfe335a6a326a53ee47dc7027ccc26c911"
    sha256 cellar: :any,                 arm64_sequoia: "03325eb9b5e663073aedb7f13e975a91d5aa8edb943e71ba52d065128105651f"
    sha256 cellar: :any,                 arm64_sonoma:  "d62af819826bc4e9ee6a3dceef659d424090f9629db566a3a18eb0f580106888"
    sha256 cellar: :any,                 arm64_ventura: "7197a6fa7f40caa23c06e2a8276c199f1e35a0284050d7042711a278725045ed"
    sha256 cellar: :any,                 sonoma:        "c62d9319100ce6332a7c6335c3365b2e2a216f7df9aa5bf1daae891bdb88edd0"
    sha256 cellar: :any,                 ventura:       "902b4b280d60b9ce71177d3ff0bc0e87213afa56f99b418fd02ec57b748fc6a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4347742f36796e398b33430cd91fd1935f50aa73473dfea2aedb48bf62b5943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4031d0484219c9a701184de11ae283694a3e1067a0103ff661a29e165acc52b"
  end

  depends_on "pkgconf" => :build
  depends_on "xtrans" => :build
  depends_on "libx11"=> :test
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/ICE/ICEutil.h"

      int main(int argc, char* argv[]) {
        IceAuthFileEntry entry;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
