class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.4.tar.xz"
  sha256 "d0708a63f05b79269dae862a42671e38aece47fbd4fc852904bca51a65954454"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fb39aa9778e6e1b6b8231e89a1439168aa4d72c364badc5fb1281fb7bdfa5027"
    sha256 cellar: :any,                 arm64_sonoma:  "e231f1d4599a8ffa3780f1fa8c085206d97876c76245e24caa1fb1f0eefa5185"
    sha256 cellar: :any,                 arm64_ventura: "92213744cc0d2d3cfb63210c74d568bc419b9e05b931a4fd071fc52d3a86c7e6"
    sha256 cellar: :any,                 sonoma:        "39e3b4f3b35bced06080783c4133c4eb1afed485e1926d7bc528a6dab35bc30c"
    sha256 cellar: :any,                 ventura:       "d1f6bb9bbcc462334e74ce56d03175287047ebffe0353b5bcb788288a9a15ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b445b25ec0a944c92043b4eca33e65a3150e4f2c2e168dfecb8ed9c21000e78"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
