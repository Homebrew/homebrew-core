class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.13.0.tar.gz"
  sha256 "4fe99247a718dc1038cb6b9b1808c8e836bbf6a8464afefddf4bf8a161b08236"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b74c6842567e63a373ae138e919298930773e84358fdf732b6ee06b4aa8476a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99fd27cbc911377b60c376fc991f532be082c8b825c4e4ea1368d3d7fdea3187"
    sha256 cellar: :any_skip_relocation, monterey:       "a94769da2053182cfa2620b1314829d2a2dac564f5c7be269216ce2251ae616c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4070d8a638416e31faa2aac747a445b969f2a0479710d5a0184aced5e03e9a5a"
    sha256 cellar: :any_skip_relocation, catalina:       "703ca74cee2903b74281bd88a091d1f425a2c6d1739b44a930dd0d640b6b9ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3eb6f7a80fb704c89f3ce1607a356b2e31b9c43e0a1dead6a1b6cf7ddd5542"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
