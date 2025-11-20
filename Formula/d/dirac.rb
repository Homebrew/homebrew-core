class Dirac < Formula
  desc "General-purpose video codec aimed at a range of resolutions"
  homepage "https://sourceforge.net/projects/dirac/"
  url "https://downloads.sourceforge.net/project/dirac/dirac-codec/Dirac-1.0.2/dirac-1.0.2.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/dirac_1.0.2.orig.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dirac/dirac_1.0.2.orig.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"
  license any_of: ["MPL-1.1", "GPL-2.0-only", "LGPL-2.1-only"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "67319e9ad9710a1d9bb80f78716b453430f164ed95a0b45ad62bad1bccbd879b"
    sha256 cellar: :any,                 arm64_sequoia:  "53157665a3a8ba4676115ebedef7b7428ea51424674d1af294383cc94c9572ff"
    sha256 cellar: :any,                 arm64_sonoma:   "f2cb5520feb1c9b6ee2803f926c5e5499042ee0813d366a4dd67d425f30f365e"
    sha256 cellar: :any,                 arm64_ventura:  "7bc947bb9a57486227216595ad5e62ece0deba0a467b1e62e0f1e549f3dbea64"
    sha256 cellar: :any,                 arm64_monterey: "694f2245011fc14041cbac4d527cd1ca5feca5220ae7aec7dd2f407d3a72bd83"
    sha256 cellar: :any,                 arm64_big_sur:  "fd13d2ad2ae2be488a3667d58a9ae207a12afe17826e6d8fdebf454bba4a543f"
    sha256 cellar: :any,                 sonoma:         "bf547d33dffd0442908ab57c0aa4bfcb59c5943112f260b31e6e0aa2fe6c0469"
    sha256 cellar: :any,                 ventura:        "da8aa90563093bde9f95ce1bed46e85150f9d57afdc35a2af8544ba5f9921cb6"
    sha256 cellar: :any,                 monterey:       "0b0310b8b2213e9d86cf414331130f4effd792609be95e1015932420328fbb91"
    sha256 cellar: :any,                 big_sur:        "2d6aa7e4d9c73e1a79b9b23b86ade670324755806276d6061ec1b3e9f444548a"
    sha256 cellar: :any,                 catalina:       "8c4a433f067fac458d219eaed956744d84cb9069334df82a3745e6f5f24aa686"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c02ecb26cb2992df035ad54868de88e9706b0abecf9f949413bc584b9eea8a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96695c27a2cd1fbabc1281d052e798b4da85d75ba1a92c6b072808d0a59c62bb"
  end

  # First two patches: the only two commits in the upstream repo not in 1.0.2

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/da8a53abcf057c58b498/raw/bde69c5f07d871542dcb24792110e29e6418d2a3/unititialized-memory.patch"
    sha256 "d5fcbb1b5c9f2f83935d71ebd312e98294121e579edbd7818e3865606da36e10"
  end

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/e729c459525d0d6e9e2d/raw/d9ff69c944b8bde006eef27650c0af36f51479f5/dirac-gcc-fixes.patch"
    sha256 "52c40f2c8aec9174eba2345e6ba9689ced1b8f865c7ced23e7f7ee5fdd6502c3"
  end

  # HACK: the configure script, which assumes any compiler that
  # starts with "cl" is a Microsoft compiler
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dirac/1.0.2.patch"
    sha256 "8f77a8f088b7054855e18391a4baa5c085da0f418f203c3e47aad7b63d84794a"
  end

  def install
    # BSD cp doesn't have '-d'
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1700

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
