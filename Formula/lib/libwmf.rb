class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://github.com/caolanm/libwmf"
  url "https://github.com/caolanm/libwmf/releases/download/v0.2.15/libwmf-0.2.15.tar.gz"
  sha256 "bbc90f22b9e86d5f1890d7da11cf7a8e61f429d4c220d900c285021deabe7a52"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-2.0-or-later", # COPYING
    "GD", # src/extra/gd
  ]

  bottle do
    sha256 arm64_tahoe:   "2c6e1d26d2213cbe408a6289a20cab2d9a385babb56997ad30afc0c733f89569"
    sha256 arm64_sequoia: "648aebf55487d4a5dffd40319f0fc2309e1cfb075e88a27dc03e777f9c8d6f5a"
    sha256 arm64_sonoma:  "b69efed6e318df46ace734007e3099d1d08dc5753b56b0b9eb8e6fc111083209"
    sha256 sonoma:        "96d66c997be9b333c085daeda09d2ec1bca0613cfbb6ea66b5ec6bfac260129e"
    sha256 arm64_linux:   "71f7063942f28d921e37b56cba7b7a323ac3d27fde289ab4adc4f1dabf4f207c"
    sha256 x86_64_linux:  "bdf120383ed21317c5931926dcc30b3c8d662b0e0873213b321a72ec07b5411f"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-gsfontdir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
                          "--with-gsfontmap=#{HOMEBREW_PREFIX}/share/ghostscript/Resource/Init/Fontmap.GS",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    resource "formula1.wmf" do
      url "https://github.com/caolanm/libwmf/raw/3ea3a65ad1b4528ed1c5795071a0142a0e61ec7b/examples/formula1.wmf"
      sha256 "a0d9829692eebfa3bdb23d62f474d58cc4ea2489c07c6fcb63338eb3fb2c14d2"
    end
    resource("formula1.wmf").stage(testpath)

    output = shell_output("#{bin}/wmf2svg --maxwidth=100 --maxheight=100 formula1.wmf")
    assert_match '<svg width="100" height="18"', output

    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/wmf2svg --version 2>&1", 2)
  end
end
