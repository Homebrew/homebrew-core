class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.1.tar.gz"
  sha256 "1f4d709ebba37eb7326eba0e665e0f13be4fa24ee35c95b0d79c30f14a348fd5"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1e24f7e58c83a9d5e7b8aa03d6f585e126238f4eaf4e9a0cdfb5fc6a066b7430"
    sha256 cellar: :any, arm64_big_sur:  "4e7b1c05be6aec0421ce1a0504047b80ca4f6acef5cebf25fbd0ff51e83e4c9c"
    sha256 cellar: :any, monterey:       "4ea5c73d6392527698e9e82db9c541c0e1eb3944e7103363163f59c3573fcabd"
    sha256 cellar: :any, big_sur:        "c84d2df11a31969f91e8d03aae0b6e21220835f8e0c12d81808ed9126aa0283b"
    sha256 cellar: :any, catalina:       "d28486b555358a932c8d4f93aa7d2c2384f867426fa060812ae3fce7204a9013"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
