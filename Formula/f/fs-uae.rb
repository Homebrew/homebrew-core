class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://github.com/FrodeSolheim/fs-uae/releases/download/v3.2.35/fs-uae-3.2.35.tar.xz"
  sha256 "f3d3cb8d3df34b0b0125c45a5a3e187ff71050be5dc8455cc4505c0380269117"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "741ffe6927eb47d81ac9b456c89289250398f7d5b2baf6d353876620406f726c"
    sha256 cellar: :any,                 arm64_sequoia: "8cf15d35c2e0a8964ad55a1b42fe2b8bf0411af03e2d854cae780c8cacacd94e"
    sha256 cellar: :any,                 arm64_sonoma:  "5c7aa678ddfa3c123c46d29ebdbbf32d0b26e014ea191a85b427126f47cf3c31"
    sha256 cellar: :any,                 sonoma:        "5cac6160964a608e299f905cd36bbba764f7dc6130d0dd908f472ae2d3667de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322f417b0344b31e267e41f328d9ae6281be7310c286bf2e61c3e162891ad349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0685abd95a223cbf2af21a16b4f78dba2c73169c79a16d85063d7b8b3514078d"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zip"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
    depends_on "openal-soft"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap" if build.head?

    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1400

    system "./configure", "--disable-silent-rules", *std_configure_args
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    rm_r(share/"applications")
    rm_r(share/"icons")
    rm_r(share/"mime")
  end

  test do
    # fs-uae is a GUI application
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
