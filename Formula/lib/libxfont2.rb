class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.10.tar.gz"
  sha256 "f43ccbc4c65f24ee1d5130cf96e0f2146f34c41461d461625804df995809f5e5"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fdf812eece2209a7bf52fed52b6658bea7b651aee03a95996fb69dc6968a4136"
    sha256 cellar: :any, arm64_tahoe:       "ce5c825e6595df717295ca49419962867c400fcc10a86d2acb79b7a28209f884"
    sha256 cellar: :any, arm64_sequoia:     "1315cc810bc802797f0250acf4eacb23de0851d251b21ce8284b33f80abea9e1"
    sha256 cellar: :any, arm64_linux:       "7a8af606c8ec92a1e3075497e1d5a92e73c94159215c305871e4232cabfee1ca"
    sha256 cellar: :any, x86_64_linux:      "76e8046945c94f1b3ff65b8113e7b7ad066c0b50e4a005d624e17a927f7f43fd"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => [:build, :test]
  depends_on "xtrans" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    configure_args = %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{formula_opt_include("xorgproto")}",
      "-L#{lib}", "-lXfont2"
    system "./test"
  end
end
