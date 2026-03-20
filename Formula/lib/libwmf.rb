class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://github.com/caolanm/libwmf"
  url "https://github.com/caolanm/libwmf/releases/download/v0.2.14/libwmf-0.2.14.tar.gz"
  sha256 "a1a0affe80fb8d0e1c71eb7e99fbd17034ac575fb82d338b2c079995c25ae6ae"
  license all_of: [
    "LGPL-2.0-or-later",
    "GPL-2.0-or-later", # COPYING
    "GD", # src/extra/gd
  ]

  bottle do
    sha256 arm64_tahoe:   "faf6abfcf586e8a31abb4adf7742038ef80a5bc113f1f823090b6a288f660b44"
    sha256 arm64_sequoia: "146b0bf3be1df181e0324c011bd0e4374d64cee44a227f52ab2d84fffe20b382"
    sha256 arm64_sonoma:  "fd5547523d6825e37482df328b813d77f33406f7aeea2a623969973415991a37"
    sha256 sonoma:        "68000eda7f0280efa360d74723365f0ec9f5e93016ec74c875db546e2a5fb594"
    sha256 arm64_linux:   "1c911a8926c22d6b84820616bed109c7e9dcb4c1cdf20544d1a696dd11170a66"
    sha256 x86_64_linux:  "359e45d8b108c0891d96f4db7870a7a643af455e7459fdb0fb9055ce0fcea069"
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
