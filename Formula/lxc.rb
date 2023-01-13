class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.10.tar.gz"
  sha256 "b182643ebfed136db12448ca5fb7cc8ce2d0f730439b9d948ea6d52eb9b7f735"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467d364d1941a462a8588cb60c61343e802531bc1c65f565d510bfe90d513caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc6dddc5aa8a78bad4927d23d5ef711cfa16de232facdc1ce8342e18d879d8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c70bbea1040521babec2392f95e43fe026e4bcc2703c3500e7c253c1ba69913"
    sha256 cellar: :any_skip_relocation, ventura:        "2e00016e37da68d54e19f91c1e18a60bd1469e8e11fce396554f479abbcb513c"
    sha256 cellar: :any_skip_relocation, monterey:       "72961a6bf0108a0bc97154ea1201291a8a9019dc7dbe22e5d311c6ffd2952040"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e4b6747167dc4a2fad050f5cd93a9dc2ddb1ffe8d7d75caf3b0b0be54310fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e2ccb65311eb39f3a056858a41ca4b2cb924f599a92b2d7a7e8f00464889c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
