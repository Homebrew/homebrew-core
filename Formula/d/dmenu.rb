class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.2.tar.gz"
  sha256 "d4d4ca77b59140f272272db537e05bb91a5914f56802652dc57e61a773d43792"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "708fb141f7f49b0fc4bfb8daeb000d94f5f326fb651f1ee58c48b516a525b633"
    sha256 cellar: :any,                 arm64_monterey: "a38c53bfcb397d64e0d2711133111952681107e90c312fce10e2c05e00453910"
    sha256 cellar: :any,                 arm64_big_sur:  "e0780e17a41fb6825390ab8ea583335cb5be93450bbf5feba9f2bfb3ba62d743"
    sha256 cellar: :any,                 ventura:        "61b482dc8562108d21ccd849fbd6f143c190193f8cb83fb066fa7afbb1536514"
    sha256 cellar: :any,                 monterey:       "d1ee5fd7bddff131aa64cb50985001d002b127c84253348a789186e9d7b67ec8"
    sha256 cellar: :any,                 big_sur:        "ae03a3e95ded418ebd8a249ccbf0a026efd64a41cccb53090075519a72670fc7"
    sha256 cellar: :any,                 catalina:       "30477f6f373029ad6e4629c28e45d579770b3f89c2c8027d5245ae4b41ed18bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0e7be290b1206f50abe98659c2594d1d4ef4983cd7e63932108cb0b19d892e"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
