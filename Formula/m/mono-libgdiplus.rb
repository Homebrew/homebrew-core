class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://dl.winehq.org/mono/sources/libgdiplus/libgdiplus-6.2.tar.gz"
  sha256 "683adb7d99d03f6ee7985173a206a2243f76632682334ced4cae2fcd20c83bc9"
  license "MIT"

  livecheck do
    url "https://gitlab.winehq.org/api/v4/projects/1906/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1) }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6660ea5c589c9a33ad3ac95463935c5374e524e7bb8b924a4ea5e5c257085f4"
    sha256 cellar: :any,                 arm64_sequoia: "98055b3665fb3bb6d5af85a6e7e16f1a5be9f2fe201b6d1ef72a5bfa49e5d07c"
    sha256 cellar: :any,                 arm64_sonoma:  "9332827231368d618a2147d91cc8996215200bb70dcb58129fdac2544e7e8351"
    sha256 cellar: :any,                 arm64_ventura: "fb92a8c1f346c8e8838bfad994b109e0a9c76ae1f96793f9f463847065d32575"
    sha256 cellar: :any,                 sonoma:        "c0e21d48bd5a014b7e9517fc1773bde665297d0a8e114672b0e9556dd0427df2"
    sha256 cellar: :any,                 ventura:       "cac30e4240d9663ff31ed55835d30408ce2d19cb6606f3c285e2e943d578a777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70171e88a695d0f1e427c54027595d2bbfd0d188b5b33f9b490bd968fbdc93ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e81d0121eb441eedf7ba8369a49c26970bb16f461f97d54753c68a08edc54e"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-x11",
                          *std_configure_args
    system "make"
    system "./tests/testbits"
    system "make", "install"
  end

  test do
    # Since no headers are installed, we just test that we can link with
    # libgdiplus
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
