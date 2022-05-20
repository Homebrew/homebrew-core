class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.7.tar.gz"
  sha256 "dabd5f7b883f806483b2a5a879c583840cdda74dc6f3d3781b1b375744e9feac"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1458efaa4be0fc56ac4a6a969b2300e349b1c847114c88e095e12c9a0bad96f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c9483e3d20a000df560343d7f51e1e6451f7d069dc5ebd3ab8ebde95e9691d8"
    sha256 cellar: :any_skip_relocation, monterey:       "34efd719d9c83cca8f846b7ea75dea398c15e2333f28f7ce1f9b2bfac57a0cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b66039e0fe378db420419624650c006acd9e13aff32c38a1a7f3c8d20006c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f5d14c3c4b5c6f282215a026fb8a9f109d198cefde354cc8b9e4b6c212050f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e1d193a8d1693bbc0399ff007e1c8eb93f788f333869b9a0c3dee45b8c8e3b8"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
