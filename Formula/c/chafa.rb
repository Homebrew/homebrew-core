class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.0.tar.xz"
  sha256 "670e55c28b5ecd4c8187bd97f0898762712a480ec8ea439dae4a4836b178e084"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2938cf2d5fa6a13ebb9306ccfb80bcf8d36c1cc6315a23875651b1674677eb3"
    sha256 cellar: :any,                 arm64_ventura:  "03aa1de31ce7759d8dd946b261ca787ca87becef5b8c0e540e6734ab8d7de277"
    sha256 cellar: :any,                 arm64_monterey: "92115c2d0ae46d235e0b0d1eecf8b5c391a42a9954f313144b3292787c75c4d8"
    sha256 cellar: :any,                 sonoma:         "2a7249b0be19eb4ec0521f678cfeba4b722d08233f7bc8e6bf60c8a4c082d99d"
    sha256 cellar: :any,                 ventura:        "d560ead52b64026144a1c399ed2f0309ade43b707ecc8bbd30af39c8f9863df0"
    sha256 cellar: :any,                 monterey:       "3bc01c8ba9af6d7096b915d8d326983a7bc61fd8de9b301e7f003a36062a6aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2178cf3b4f3c75e3d964455172c9ad2eef8f07f6997848ca6b265919b5fa2a"
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
                          "--disable-silent-rules"
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end
