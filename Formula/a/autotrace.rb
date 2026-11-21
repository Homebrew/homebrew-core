class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.12.tar.gz"
  sha256 "0db44ad1be129ccc679f5c314d3f041528fcc111e1210c27f2546dad9793cb6f"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "45a0cdaf5ee134c77e6713eeafe02ffb253d960898f69af9db0a4a0cf388804a"
    sha256 cellar: :any, arm64_golden_gate: "e26e35d0c385ff46b0a12d8f16ff30077e85c4d92c591870517907a84b58d6b2"
    sha256 cellar: :any, arm64_tahoe:       "fa8decd260ca7ffd12dad62ed80482a5620384adea834a14fdc30e8dadaa0645"
    sha256 cellar: :any, arm64_sequoia:     "cc13bdfe7c314d3cd77fd39da2c4a84abe9dea3231acea52dcb0cd09edeaaca5"
    sha256               arm64_linux:       "cf648a7d2b5b3215d8af58f1dcb1cb36bc2f349bbec117e298312837710e74ec"
    sha256               x86_64_linux:      "07d670cad403020630f77c5a3c02ef128804b2ee7436d4d20aacc7ccb74b07b3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pstoedit"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--enable-magick-readers",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "convert", "-size", "1x1", "canvas:black", "test.png"
    system "convert", "test.png", "test.bmp"
    output = shell_output("#{bin}/autotrace -output-format svg test.bmp")
    assert_match "<svg", output
  end
end
