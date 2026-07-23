class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.2.tar.xz"
  sha256 "0b8d9ba9f347e8b6c0c71878217c9b0e478b4a42aa4babea0bf20840567239c2"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50845c434e04dd24ba094b154dbafddf73254170614149c35eeee937da69fb83"
    sha256 cellar: :any, arm64_sequoia: "7a1afcb60ca9729a97a000130f3368115aa7f8fd2386671ce32c5a7f76104021"
    sha256 cellar: :any, arm64_sonoma:  "b0d8646c0955ec9efd2f8be4a651521624c88f91d3ac789913717cd694f2351f"
    sha256 cellar: :any, sonoma:        "9e76a9ec0ebf6fdaeaa75859a7a8a4da97e17efdb12e58111f1d35bd6ec518ba"
    sha256 cellar: :any, arm64_linux:   "c98df6a020fa9c5decf7cdb558b075b3ab1a6673e9911e04f1765cd2e009d59f"
    sha256 cellar: :any, x86_64_linux:  "aaa303f5ab0b3b6c4afe51a50e6f91f23d2886f1c7a89e7211c419bac83254a9"
  end

  head do
    url "https://github.com/hpjansson/chafa.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    with_env(NOCONFIGURE: "1") { system "./autogen.sh" } if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1" if build.stable?
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
