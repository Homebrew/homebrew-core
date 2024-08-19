class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.2.tar.xz"
  sha256 "8a28d308074e25597e21bf280747461ac695ae715f2f327eb0e0f0435967f8b3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4d628175d8e1370d2c029725ca5dfed28ae8557202a05921a09ff4a8d36695c"
    sha256 cellar: :any,                 arm64_ventura:  "e9559f683e16db079084e8f2e07b8b7935f669eac0a83cf3133c368ed33cdf53"
    sha256 cellar: :any,                 arm64_monterey: "efd04351d4046b6ffbd52893186127f8f373fe4b781fb0c127161bfe9169f22c"
    sha256 cellar: :any,                 sonoma:         "684159ed9101150b5612f7e2bc901cee76581b7882fb8531e93fd791b608256b"
    sha256 cellar: :any,                 ventura:        "a3275323cdbbe2c74381636c1441d153cd06bc8cb4a197ee68c80312a38d19af"
    sha256 cellar: :any,                 monterey:       "592ffcf3776f9454f4f035da2b35624e64b553ff3eac4baa276e222851fd5c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9013544016acf877bb9d6c346ba0ea9c79ce8107e54788dfd6e098342cad2ca"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
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
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end
