class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.17.1/fontconfig-2.17.1.tar.gz"
  sha256 "82e73b26adad651b236e5f5d4b3074daf8ff0910188808496326bd3449e5261d"
  license all_of: [
    "HPND-sell-variant",
    "Unicode-3.0",        # fc-case/CaseFolding.txt
    "MIT-Modern-Variant", # src/fcatomic.h, src/fcmutex.h
    "MIT",                # src/fcfoundry.h
    :public_domain,       # src/fcmd5.h, src/ftglue.[ch]
  ]
  head "https://gitlab.freedesktop.org/fontconfig/fontconfig.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+\.\d+\.(?:\d|[0-8]\d+))/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "20f30c771e40a924e423a9652080c7097e16782ffb236344c368721c001b78a0"
    sha256 arm64_sequoia: "357516db5db5eb0cf5936333ef5845e600a0e01fbe80909b994f159b9d18bb22"
    sha256 arm64_sonoma:  "d3d81ce82b7fafa924ca50adb5199b952f9f6706303d599e6bee0c476ece908b"
    sha256 arm64_ventura: "8f07f7c568de41b1229cc5d437763739d4f3e892e9aa17b94fe9415c80ea40c0"
    sha256 sonoma:        "ca0deb10e43960476c8c417e78f14e81bc2d0674c7860db8efb842d206093137"
    sha256 ventura:       "71ec3020d8de2aebed88452f49748554e318b1dd0054a5d540820586b2488ac0"
    sha256 arm64_linux:   "e85111ea1b81f0bf5505a3319187b3b2ede73aad67b9142ceb86132bdece1a61"
    sha256 x86_64_linux:  "2c1073429bebddfa34e272928799517b246e6a44722ac567a1be66692750d99b"
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
      -Dadditional-fonts-dirs=#{font_dirs}
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
