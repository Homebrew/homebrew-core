class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.3.tar.xz"
  sha256 "2456a0b6c1150e25b64cd6a92810d59bed3f061f8b86f91aba5a77bc7cc76cfa"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "818fa732dc4aa6229c69aaeb476a4d57de2bcb639797df6d55dee4500a4852d7"
    sha256 cellar: :any,                 arm64_big_sur:  "90878741b816301f3d7b8def45e1514d1bb9a338b805470f1ff9f343a2e763ea"
    sha256 cellar: :any,                 monterey:       "78498759544048da8e55411603ccdb600917427713abde9345a5f40feb975604"
    sha256 cellar: :any,                 big_sur:        "91d4b3b443b0413aa8e7c250d764f2cfced89ce62218aa13cc9db512651132aa"
    sha256 cellar: :any,                 catalina:       "9c0092011f71a7e3492f87418cf53268076327810bdb92c93be0fc1e669c6722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50dc81866e819117ff2b8a48ca06d4c18c660d01de2dbe161e950b2f9724cb29"
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
