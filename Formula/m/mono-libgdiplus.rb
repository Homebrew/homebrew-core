class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://download.mono-project.com/sources/libgdiplus/libgdiplus-6.1.tar.gz"
  sha256 "97d5a83d6d6d8f96c27fb7626f4ae11d3b38bc88a1726b4466aeb91451f3255b"
  license "MIT"
  revision 2

  livecheck do
    url "https://download.mono-project.com/sources/libgdiplus/index.html"
    regex(/href=.*?libgdiplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "730e4aadee862473e9256273d98a9bf3560a202ed9998a8a44f30bdf3f47284b"
    sha256 cellar: :any,                 arm64_sonoma:   "17bb690baf4c81a255f8aaa4dd26a3fe213107d435a09056edf75fbe20a96f86"
    sha256 cellar: :any,                 arm64_ventura:  "baa165d73925f5841420b2fc30e940f6e9e41feae17276008e9c9749a5aedc43"
    sha256 cellar: :any,                 arm64_monterey: "c6aa23ec4f0567c5fbc66d2f337154d027c445ce5e185e9add426abe2421b2b2"
    sha256 cellar: :any,                 arm64_big_sur:  "0d867f4956abbc40cbb77e02fa065e29f9b542cf62c241c8b9bdd63d1545386c"
    sha256 cellar: :any,                 sonoma:         "fcfd56c45fedb582eee479197e13c10ec528f6d36f3ba3ec94803c7cfdd98c21"
    sha256 cellar: :any,                 ventura:        "914cd00240487b6f029a094d0daf4817bfee298061550b35a0b43d02ddf62af9"
    sha256 cellar: :any,                 monterey:       "2007d0ab77950b6c610e2285c3bee3d86f40bda83741b03b5a2ffe170e0dff74"
    sha256 cellar: :any,                 big_sur:        "8dc5b4a3e00eef554d5a96cf6978c6da43e60cccb9d623e22d913b426f050ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fcf152ac3af7197f76f21cfa77bb58b9b06c735f2626e8d1a84079f8d47063"
  end

  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-tests",
                          "--without-x11",
                          *std_configure_args
    system "make"
    cd "tests" do
      system "make", "testbits"
      system "./testbits"
    end
    system "make", "install"
  end

  test do
    # Since no headers are installed, we just test that we can link with
    # libgdiplus
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
