class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/FrodeSolheim/fs-uae/releases/download/v3.2.35/fs-uae-3.2.35.tar.xz"
    sha256 "f3d3cb8d3df34b0b0125c45a5a3e187ff71050be5dc8455cc4505c0380269117"

    depends_on "sdl2-compat"
  end

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "ee522d2e31575f20c60bda81e467c8d600633adcca5fc5031d4f5cefe77ef062"
    sha256 cellar: :any, arm64_sequoia: "e186258960cb997078bf0cf93d91ed86a8ae7e6c03b25de135ee39ab56ef6292"
    sha256 cellar: :any, arm64_sonoma:  "fdcd632bdc65ae88f41a9b9099e40690be32cf4f2a23c439ee36cd1aec030023"
    sha256 cellar: :any, sonoma:        "cdc65ba8c83d6f2d80edc7581997763aa5b854b058cea80181a87827142fad37"
    sha256 cellar: :any, arm64_linux:   "abd9d0e315ca10dd3cfa9616394d99b46e027e52c7f00011cc5a390c7b908fe5"
    sha256 cellar: :any, x86_64_linux:  "2e41777b8625503a667aac3bb8e2050317bb37411a8b39323c03f67e317f003f"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "flac"
    depends_on "mpg123"
    depends_on "python@3.14"
    depends_on "sdl3"
    depends_on "sdl3_image"
    depends_on "sdl3_ttf"
    depends_on "zstd"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"

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
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Remove unnecessary files
    rm_r([share/"applications", share/"icons", share/"mime"]) if build.stable? && OS.mac?
  end

  test do
    # fs-uae is a GUI application
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
