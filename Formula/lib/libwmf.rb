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
    sha256 arm64_tahoe:   "605434c1ac87dd6e0a72de4e8d74a6e2701f1048c3da2ebbe6af570c18dd3ee6"
    sha256 arm64_sequoia: "8349a368a01bc74f298eb1f7ba3a7b66ce7807d4fd32957c7713caaa52107317"
    sha256 arm64_sonoma:  "ba24f0c59a437bf0e82d7cb946b841894544cd1c23e2c867a0d171cdfd2ea672"
    sha256 arm64_ventura: "9e85223008fa0b081256f5c6e94200dfb4610394be5dc25b782125c36b69417a"
    sha256 sonoma:        "b85946372c5e9a9f13d1a8299553ab0e5b4ffed45429b785fe5281175d62e3ba"
    sha256 ventura:       "a889684fd9d5bf65349b30808ae820014a2f72650b23d35e8f7a01cb887f3aef"
    sha256 arm64_linux:   "80bbb71aed983052b36b9ca4de431ff2269e68b0e0549f70450bb16d21b9a5cb"
    sha256 x86_64_linux:  "486038114925fd4a2e2203ae86931276b4b82fda8e47f39772a123c3adffa37a"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "expat"
  uses_from_macos "zlib"

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
