class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.2/fontconfig-2.18.2.tar.gz"
  sha256 "a84d41b57cfb015783d7973b398c26d8763a64b803f97f31fa126fd2aa5eaaca"
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
    sha256 arm64_tahoe:   "75e19bf0d345662b39fc75781a71f3eb3c923a313a4f906c2f93a1a769846a3d"
    sha256 arm64_sequoia: "9b40acd35a7ad23bf19a9f900a6a24ae81b6c13d3c71a6be72358e76421a2abd"
    sha256 arm64_sonoma:  "127737264b09996c7aaac0a42ec0992f6403c123a2470a646d8cb7f1ba7bf28f"
    sha256 sonoma:        "4a0960e023e5e85274a1514ba4d46b102e7284df2838266dfbb8a80a44b2d81e"
    sha256 arm64_linux:   "fa8d891fc7239268e499c53791f621b54441e3761ca5bc746e4ca0133b7bdb02"
    sha256 x86_64_linux:  "c795ecd6a4a052cd20755ebb00b84c4745850b9d52f4aac01cd0b30acc97d74d"
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

  post_install_steps do
    run "fc-cache", args: ["--force", "--really-force", "--verbose"], base: :bin
  end

  test do
    system bin/"fc-list"
  end
end
