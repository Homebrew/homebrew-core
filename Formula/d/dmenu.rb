class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.3.tar.gz"
  sha256 "1a8f53e6fd2d749839ec870c5e27b3e14da5c3eeacbfcb945d159e1d5433795f"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cd2aa831875be36cf4b70d2ca1b74ed2d8a652fbc040738a65ca31affeb2a312"
    sha256 cellar: :any,                 arm64_sonoma:   "351c0e07f7f4d729ccc4aa68c72aa5c0a4a58b612b07ff395d90dcf43d36a8d9"
    sha256 cellar: :any,                 arm64_ventura:  "51802214393325c58ee3cbc2571b7a9b92e82d3121f46149ce35aae78e1bd9dd"
    sha256 cellar: :any,                 arm64_monterey: "0fd492daa5a3cd89f23dde5c292784faf55926d49278fa1094d79521bfb6b993"
    sha256 cellar: :any,                 sonoma:         "c39dc953009890c423d335046ef11928bb30265dc6dfda78acff84d715e79e18"
    sha256 cellar: :any,                 ventura:        "d6b512a8f65209bcec6f5880536229a6759df63320f5c58c38d129e133008e2e"
    sha256 cellar: :any,                 monterey:       "02ea9509edf2450330ab9d3351fa9671ae3198f09981e1288b806ae7952da028"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "00ef849437676f26e9a00ee2a88addd3b9360d10bd9edeb8552463a5c0c9bc7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61976695e10967a0baa33883aef22eebc3c5b92dd54e2c873732bc4760f16a39"
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
