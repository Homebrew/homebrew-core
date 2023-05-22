class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.5.tar.xz"
  sha256 "0f5490d52a500a6b386f15cc04c6e8702afd0285d422b9575b332e0c683957f2"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4622be92c5baf043912c8ad8b8e618b14833c5be642f1894386ac64588ac1a5"
    sha256 cellar: :any,                 arm64_monterey: "9df34e0e3363d9159c375f3bccb7303afa31739fe0bee2a156e3d27265bfb421"
    sha256 cellar: :any,                 arm64_big_sur:  "e2d0d718ed250736ccb44d9e08949f6c17777d25af157176908feba2790d66b4"
    sha256 cellar: :any,                 ventura:        "55f4fa93915316719b0b872e33c0822727aa91fdfc373c5c740b8e5df196bd87"
    sha256 cellar: :any,                 monterey:       "a72e46e7729531424a7aef5a2d688fdb778048877efb3aeabfee02bc7722d13b"
    sha256 cellar: :any,                 big_sur:        "b460834a3a31a2a0c4370b2470abfa35a50eec18c12ed26b5f8774386f21d73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b9f60a8e8194e963fc3926d0afc7bbaa597def4f0df339ecaad83c0d3e4cfb"
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
