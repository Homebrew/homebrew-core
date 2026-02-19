class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.9.tar.xz"
  sha256 "9d8392705cb10803d5fe1d27d236cbab3f664e26841ce01916bbbe430cf273e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08ad2bfdfb5d488ee3aef88f8f18c08fcbf93f96eb8e611cee542997ceaf3152"
    sha256 cellar: :any,                 arm64_sequoia: "167dd0c71a50faf0fcb51f03b3e93f2afe059b1e34c7bf14e22d3bec6a86c22f"
    sha256 cellar: :any,                 arm64_sonoma:  "6b89669fe88e40b68ad42d9c41ec3a89701d60cac1592d53d76a7f023c8f35dc"
    sha256 cellar: :any,                 sonoma:        "1287de8752c34becfa9e8f7c9b485c4009fa182520304cf51c52530878cb7738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "588498decf9879a21330a600ccb23fc22f150b8097ec75b3bacc430911259aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4091913f2c2f28015d3f9acc97c008d2563b1cd39c70d2da0267f6a4a7a57dd0"
  end

  depends_on "font-util" => :build
  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
