class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.17.1/fontconfig-2.17.1.tar.gz"
  sha256 "82e73b26adad651b236e5f5d4b3074daf8ff0910188808496326bd3449e5261d"
  license "MIT"
  head "https://gitlab.freedesktop.org/fontconfig/fontconfig.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+\.\d+\.(?:\d|[0-8]\d+))/i)
  end

  bottle do
    sha256 arm64_sequoia: "b292b9e4ef57b6ed6190119972bffad4d326798f08b9ee74a1776b3eb94fc9a0"
    sha256 arm64_sonoma:  "82b87ca97b26ecb4e05d0e9b607a162b8367867ced0208499a8b68ab536ab333"
    sha256 arm64_ventura: "0b178b197586614e1836d20c7c22ff7929a02937a62269ca6eb62ad9fc3f2cda"
    sha256 sonoma:        "eccb1a8cc72ab45874424e18165753a47b16ee3919a7514d2951ee5cf0c89751"
    sha256 ventura:       "b96b22ce54b85dea093d70c68c674ff5f769a19e93094e2328be817c02741051"
    sha256 arm64_linux:   "53972abe0f04e39b2cd7995c3ef1547960b946cadf5f14d406516c5106e74e63"
    sha256 x86_64_linux:  "4a6a3a681de7722a77cf80eb1c19cec3f65a44b7898b9830eaa53ac570282104"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if OS.mac? && MacOS.version >= :sierra
      font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max
    end

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
