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
    sha256 arm64_tahoe:   "3e5fe5ced46e677b036a434f33bfad015b26ec599896e13431f90880fefc2db2"
    sha256 arm64_sequoia: "1538844d9dcd7ace123b4c55220506782726cb6803ad96a132a30e85720b3699"
    sha256 arm64_sonoma:  "f4854307ce84898d35564e9a7027cd200973736c74bc9b783a8b34cc1fffd821"
    sha256 sonoma:        "30bdb67e3e52cdd396a19668313a580850ae94ca1a6fb355d2320cd803dd1be6"
    sha256 arm64_linux:   "b78fd19a27aa988fb4b22f5381ed0a0a75010708a636a1a5c5e110d5009e212e"
    sha256 x86_64_linux:  "1006f26b98bfe4b9c032e8b93842ce5ef8b0342b7582915b5aafcb17e53a3518"
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
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if OS.mac?

    args = %W[
      --default-library=both
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Ddoc=disabled
      -Dtests=disabled
      -Dtools=enabled
      -Dcache-build=disabled
      -Ddefault-fonts-dirs=#{font_dirs}
      -Dadditional-fonts-dirs=no
    ]
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
