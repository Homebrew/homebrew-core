class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.17.0.tar.gz"
  sha256 "29cfabfd968565f834de63b7ba13a4b4eb4759b72003fb7aab5db98b060521e6"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0977a6271a83ea0e9e089502894561a683e10e2b3f60386f9a75b299c03d237"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0977a6271a83ea0e9e089502894561a683e10e2b3f60386f9a75b299c03d237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0977a6271a83ea0e9e089502894561a683e10e2b3f60386f9a75b299c03d237"
    sha256 cellar: :any_skip_relocation, ventura:        "22e62eca53b5e2f4dce35ae0dce0eb990265ed317bed5c5d4b82fb216cfff51a"
    sha256 cellar: :any_skip_relocation, monterey:       "22e62eca53b5e2f4dce35ae0dce0eb990265ed317bed5c5d4b82fb216cfff51a"
    sha256 cellar: :any_skip_relocation, big_sur:        "22e62eca53b5e2f4dce35ae0dce0eb990265ed317bed5c5d4b82fb216cfff51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c02706e201cb46b8c96d7371e444dfdb054083620a05a3c104da241681dcde"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
