class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_5_0_0/atari800-5.0.0-src.tgz"
  sha256 "eaa2df7b76646f1e49d5e564391707e5a4b56d961810cff6bc7c809bfa774605"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ATARI800[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4bcc92710eebd07c09b0701d6722f838a4bd2d6c7c79386f5b2e01d6ec2e9d4e"
    sha256 cellar: :any,                 arm64_monterey: "f49c2cf42413abdd1ba0d7b5fd3e628b794eb806c2248a0f50c4c6661d04a064"
    sha256 cellar: :any,                 arm64_big_sur:  "aa9c15ae0bf8bd5ab442836b71297d802abed3e3c7ba63ea2651dc15accd9c79"
    sha256 cellar: :any,                 ventura:        "ff0725ca690bf0e9bb6148498420d979e626aab303a8782dca4e825ec21d1a61"
    sha256 cellar: :any,                 monterey:       "a427841ac1585534dfe1e1692a662720d6ff8936cef1ca9649316ffc3099189c"
    sha256 cellar: :any,                 big_sur:        "452c89fa2cb96c4bd68939bf5f0db5cad245367e152d93721d964cf548fb18cf"
    sha256 cellar: :any,                 catalina:       "d05b2717c26e4ddf292f4ad85df1485a735e7522f965533de0856978bd9b093e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe078392f7bbbf2753bb4e42b9e02fdd85b14d60816ef8f873ffb9741aca9bb"
  end

  depends_on "libpng"
  depends_on "sdl12-compat"

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
