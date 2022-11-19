class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.4.tar.xz"
  sha256 "9774bd1a7076ea3124f7fea811e371d0e1da2e76b7ac06260d63a86c7b1a573f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "522ea3f36077061428541aad33db1f9dae249a1523bdcec54ecc8cb62069ca5d"
    sha256 cellar: :any,                 arm64_monterey: "662ec93df5f776536f7ae038ab4e9b5e7b42fc2dfb697d9f271f0a0cbc2e913e"
    sha256 cellar: :any,                 arm64_big_sur:  "a414cb89b09c05ae6049dbfd2ead73c48afa09e629e74e3a026b7b598adfbc86"
    sha256 cellar: :any,                 monterey:       "5de514b36b5ca3e73d742b9d9a80188d5469f5cf6c1b427ab079f08504052df9"
    sha256 cellar: :any,                 big_sur:        "3010b72f0b60642e49daf7c4ab1a0e9acff843938444f18c6da753001b5fe7c8"
    sha256 cellar: :any,                 catalina:       "c7dff97197a4bbaaf1a279b2b23c7fe7098d64096e2cdaee2b4c44dc7ddcea0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31620cdaed205fe14af6a67f0454304e870af8ca99d912950a84a37dda2c062"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-imagemagick" # deprecated in 1.12.0 and planned for removal
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 2, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end
