class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "20f678a9eb96f9d72b86cbdf672d4531b2a323593be1833f26464dfccbf72459"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9a7da88522507f512f7dc5fc56d0b4005bb39fd65a2dfcf0b10169fa80c4899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b264ba7cea87dfefa75ce0f4bbb49abf7b1ddc6ce661abc5a51669f08c0014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567a1e1e9cf221b01ea435fa60f87a7f6991810bae93e046eceb8c085abfed68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d9192839b9fd386a7ca5285591a15a3a322be13d8f03c5b76568e7d10645280"
    sha256 cellar: :any_skip_relocation, sonoma:         "70e66f9d9a7ce3e9745c3b753e8c7fed6b05a0a2552a4afa6014c66ad6cf09d4"
    sha256 cellar: :any_skip_relocation, ventura:        "7328c54f383d91a7e57ee6128db416f6e09de18e69ee398875beaa701ae130a9"
    sha256 cellar: :any_skip_relocation, monterey:       "970c01aba3e65857a34b265b0960bfed1bc7256246ae7336ff863b841e90e6a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "db59f5e7d30f84be2b68a9c568a2dc1d7dcfa19fcd65c2f9139c6d90547dc5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b51ba451a1bfb269fb542af99adb9e36773e0b0f063f3d5120ace928a487696"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
