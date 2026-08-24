class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.3/fontconfig-2.18.3.tar.gz"
  sha256 "9ae01e1d53acdef56010c5451cd34aa41d325b2faccd8606448d8fa01b2496b3"
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
    sha256 arm64_tahoe:   "ad1c5a3054313853e9eefa9a07c32a3ff7b11c4fbcff9e73affc2a50233dbafe"
    sha256 arm64_sequoia: "a5f5df5f8d02e8a5b2587cac464c7bd45128447da06b7ab39938a9645982ef49"
    sha256 arm64_sonoma:  "24bd9a2d42f9bc46d4cd51aa51299cbe2c59b2c848656a7657875b0aaedc223b"
    sha256 sonoma:        "dbc9016619292284590e7e16e6492d911e0926b976ebe6d502f6e86fe01fd64c"
    sha256 arm64_linux:   "8e7ed20aac7298e92bfb46c5fbb34fd8784f111507e256fde4f2fb354f1c48eb"
    sha256 x86_64_linux:  "56c35f5cc20e978189ba6693eef8ed1167de1d04ef9e5289e9a9dff8b5077049"
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
