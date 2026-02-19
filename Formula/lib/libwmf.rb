class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://github.com/caolanm/libwmf"
  url "https://github.com/caolanm/libwmf/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "18ba69febd2f515d98a2352de284a8051896062ac9728d2ead07bc39ea75a068"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-2.0-or-later", # COPYING
    "GD", # src/extra/gd
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "19feff47e82f7eff2624ec04a9a1b5c72d1df746d27f19a4c578f834ee8aa32c"
    sha256 arm64_sequoia: "a4cf16a67d3ee2bdf43066b5f6e160c7c217bb468606e8c820ccd5ec5fed53d9"
    sha256 arm64_sonoma:  "14cb4bd3113ffb89a0a18078e2b21ff3bb9f2a77effadd4d118492ab09c4caef"
    sha256 sonoma:        "bf0bef3b212b37300cdbd211d3dbc117ee26b2a34c741b469a58c74bf3d68e24"
    sha256 arm64_linux:   "8fcd07ccd736bd5c250f275e210a91e67676c5967d9c145f830d35fa5542dddc"
    sha256 x86_64_linux:  "4f18bbf891a0527c1dbcf305d43425b9d52b9d19250c8f1382121947d305cc1c"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport fix for macOS
  patch do
    url "https://github.com/caolanm/libwmf/commit/5c0ffc6320c40a565ff8014d772670df3e0ad87d.patch?full_index=1"
    sha256 "80ae84a904baa21e1566e3d2bca1c6aaa0a2a30f684fe50f25e7e5751ef3ec93"
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
