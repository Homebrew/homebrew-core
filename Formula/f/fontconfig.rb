class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.4/fontconfig-2.18.4.tar.gz"
  sha256 "cecf4125622ed674d5630b6deaeff43e3695afe197bdcc560363a1820d858112"
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
    sha256 arm64_golden_gate: "824ffef57aa041532e77a53bdbe901520024407d24e12db562a7dcc1eb9eaa6f"
    sha256 arm64_tahoe:       "3eee46f2e8f28d1afc33ca4cecdddfc7af61bbb91a63909e35b4801e788f088c"
    sha256 arm64_sequoia:     "cec32d9ebf57d27a1c7e7b306d6fa3fdbbaeccfeec06d14ab5a6d46662b1820b"
    sha256 arm64_linux:       "308a71f5289c679dc6a4296bf3f10130ff46d37e82fbf9af00681dd7780f466c"
    sha256 x86_64_linux:      "55e68d598670a5e9dc98cec7d5cc30b1fa64de0668360f6465d59a357fe997c6"
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

  deny_network_access!

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

  post_install_steps do
    run "fc-cache", args: ["--force", "--really-force", "--verbose"], base: :bin
  end

  test do
    system bin/"fc-list"
  end
end
