class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bvi/bvi/1.4.2/bvi-1.4.2.src.tar.gz"
  sha256 "4bba16c2b496963a9b939336c0abcc8d488664492080ae43a86da18cf4ce94f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "155c163fed69d7c9468c119e2714fbf9cf0ddaa1a6af01efb6932127ce08ec11"
    sha256 arm64_sonoma:   "72f5bcbe7c2d3b197378232499cb50417317569deaa681cc4d96bb470c5e4bc4"
    sha256 arm64_ventura:  "9ecba9b40b9d8684f4f0e60ec9a75b25b4eae26064a1eabf44d23d6a1476f17d"
    sha256 arm64_monterey: "a429b07fde21a16b3fb9352affee6ff4f8687f791e552e8fb1555ff762e620d0"
    sha256 arm64_big_sur:  "a00ec7c79ca7cf4e51681b426345a49a9ea94496086535e4a6e561a06a74af3f"
    sha256 sonoma:         "93b63e12ae36f866a493746a75f3087c3b936e47e0cb23032388470a94b355a3"
    sha256 ventura:        "e364c299057027e146cf7cd1679636ad001baf22f0eef95af5522508015ffb7e"
    sha256 monterey:       "36075283de952bc4eed2c3a24e8836352356c89d2d9ca4626c05b7ad8b4e8c1a"
    sha256 big_sur:        "e3862607efcfcf5a04da6b8bccfe6ad539866ceed49bb186e6d345c3e77d353f"
    sha256 arm64_linux:    "86cf2dff41dbd3be743b94df63db9cb7488bb6f7bb03e8104ab238e8c7e3c44e"
    sha256 x86_64_linux:   "77dc1f016b3d7d4ac604688521fe4f49938af1a7c0fd783181e6199deb2af0d7"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      out = shell_output("#{bin}/bvi -c q", 1)
      assert_match out, "Input is not from a terminal"
    else
      system bin/"bvi", "-c", "q"
    end
  end
end
