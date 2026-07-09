class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.1/fontconfig-2.18.1.tar.gz"
  sha256 "e9309564717b6301230112b173f36c288489479d381d2f0add1210ca5b16ba7e"
  license all_of: [
    "HPND-sell-variant",
    "Unicode-3.0",        # fc-case/CaseFolding.txt
    "MIT-Modern-Variant", # src/fcatomic.h, src/fcmutex.h
    "MIT",                # src/fcfoundry.h
    :public_domain,       # src/fcmd5.h, src/ftglue.[ch]
  ]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/fontconfig/fontconfig.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+\.\d+\.(?:\d|[0-8]\d+))/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dcaf4b8c5a308651cc39a24ab097b59530113fe98bcc302bb5bd1cbe6a2e0d85"
    sha256 arm64_sequoia: "dffd1a8e1eaf113055c22c1ae031341e6db31a417b3043374fe568691df3578e"
    sha256 arm64_sonoma:  "3492485e918c890cd828d19c06cfda7c8825b3705cca4d4810f4d54f329296a5"
    sha256 sonoma:        "9550776a54e32d8340966173a5d30d337a9f9984030bbdf7233eed792ad5d69c"
    sha256 arm64_linux:   "a390144d5d2e743d112ddace5726e6592c2c1c6f2fa868a5d371fc5596f5fdd2"
    sha256 x86_64_linux:  "b7e8a3cfa84aea47242a94fc4e44aaf1a35c926b761daa836428f936f468e1bd"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      --default-library=both
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Ddoc=disabled
      -Dtests=disabled
      -Dtools=enabled
      -Dcache-build=disabled
      -Dadditional-fonts-dirs=no
    ]

    # Cannot use default dirs on macOS due to fc-cache recursing unnecessary directories
    # Issue ref: https://gitlab.freedesktop.org/fontconfig/fontconfig/-/work_items/547
    if OS.mac?
      font_dirs = %w[
        /System/Library/Fonts
        /Library/Fonts
        ~/Library/Fonts
      ]
      font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max

      args << "-Ddefault-fonts-dirs=#{font_dirs}"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system bin/"fc-cache", "--force", "--really-force", "--verbose"
  end

  test do
    system bin/"fc-list"
  end
end
