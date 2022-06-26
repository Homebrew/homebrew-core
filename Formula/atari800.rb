class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_5_0_0/atari800-5.0.0-src.tgz"
  sha256 "eaa2df7b76646f1e49d5e564391707e5a4b56d961810cff6bc7c809bfa774605"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ATARI800[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83245b94b9fc95252009f5d281e486cb47e136f8e025dc962f6e6dcb2032ce5f"
    sha256 cellar: :any,                 arm64_big_sur:  "25416c8f1ee08b394cd45d2a1d0df54bf63d4efb2b5130bfcdd708fe49beb118"
    sha256 cellar: :any,                 monterey:       "2c91aa0ebc884126de90b5c0ee30531be759cb62b459eae926f48496bebf7057"
    sha256 cellar: :any,                 big_sur:        "0eb0c4e94debd54def88467d20e73b8834ba93abbe632d096bf5ccd1842dd845"
    sha256 cellar: :any,                 catalina:       "ad31bf587c7ebdd1d86a05dcb62a9c8c10c24c82fb152e235ad0f103e1243451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f59c0b6841f5a25efa197bdc9d654010474867c8ea40cfd78515bc54919e6a"
  end

  depends_on "libpng"
  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-riodevice"
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
