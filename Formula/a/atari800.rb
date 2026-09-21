class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_7_2_1/atari800-7.2.1-src.tgz"
  sha256 "b05b7b0932a19754eef42839aa0f04aa8a5ec1e55f51054ef3f802d83c7362f7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e54b7c107c468e2faaa0c81276963e11a73a0331d8c67e1111903a2abe168d19"
    sha256 cellar: :any, arm64_tahoe:       "1a78f160dba996f258401f98d546aa6a83e00db080b263399b908ea91be2ad9c"
    sha256 cellar: :any, arm64_sequoia:     "fbd24a748d2f1e8af3765c2dc2da68cf1e2fba087d64ee76de2a31117f760dff"
    sha256 cellar: :any, arm64_linux:       "f5645c9c4eb7b64d1780fdfe53f8b5e95aab0d6c89eb4c377f9539e04f33211c"
    sha256 cellar: :any, x86_64_linux:      "f1ac9b0c5df11c54667b715bcf8a084ce7a48a73a6a484c80e32cf3d7650a1e9"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest",
                          "--disable-riodevice",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
