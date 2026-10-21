class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://github.com/caolanm/libwmf"
  url "https://github.com/caolanm/libwmf/releases/download/v0.2.17/libwmf-0.2.17.tar.gz"
  sha256 "876915024b64edda8d417daf06819d03a0d18adff1fcc2f64182c69274ed0519"
  license all_of: [
    "LGPL-2.1-or-later",
    "GD", # src/extra/gd
  ]

  bottle do
    sha256 arm64_golden_gate: "006ac0141ddd8c8a424eef3c52ed99229d959db73bde36f0272946025cf8fe72"
    sha256 arm64_tahoe:       "e54795c9422298bc45a171945a33d8a026645c88163df26c4a830f4b7bd94166"
    sha256 arm64_sequoia:     "a5da283fa2b15f912c3a1eb51e0b754da5e29ad5da55742e63f821978b145fe8"
    sha256 arm64_linux:       "787faeebefce484a55f480f6fbe115fa1b584efbf84f1ef62fbc4013caf2be4c"
    sha256 x86_64_linux:      "733107730c9afef7546ad3cf374f5c5fca9ca3d12388f79fc84fe8a02f690f94"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "formula1.wmf", :test do
    url "https://github.com/caolanm/libwmf/raw/3ea3a65ad1b4528ed1c5795071a0142a0e61ec7b/examples/formula1.wmf"
    sha256 "a0d9829692eebfa3bdb23d62f474d58cc4ea2489c07c6fcb63338eb3fb2c14d2"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-gsfontdir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
                          "--with-gsfontmap=#{HOMEBREW_PREFIX}/share/ghostscript/Resource/Init/Fontmap.GS",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    resource("formula1.wmf").stage(testpath)

    output = shell_output("#{bin}/wmf2svg --maxwidth=100 --maxheight=100 formula1.wmf")
    assert_match '<svg width="100" height="18"', output

    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/wmf2svg --version 2>&1", 2)
  end
end
