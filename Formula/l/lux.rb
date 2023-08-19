class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.19.0.tar.gz"
  sha256 "901cb34542c1de1b0c847063c6c0e6e847cdb1582c7cd48a3598e050388c31f0"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ff614a3d74111be280ab7b5a2857e7e48e43afe5c9d0e80da5e5061ad9bc415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff614a3d74111be280ab7b5a2857e7e48e43afe5c9d0e80da5e5061ad9bc415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ff614a3d74111be280ab7b5a2857e7e48e43afe5c9d0e80da5e5061ad9bc415"
    sha256 cellar: :any_skip_relocation, ventura:        "91d4ba0d84e3dfb8d02ee278c6380254590d592681f3ff99bd7391d7cc2ed2a2"
    sha256 cellar: :any_skip_relocation, monterey:       "91d4ba0d84e3dfb8d02ee278c6380254590d592681f3ff99bd7391d7cc2ed2a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d4ba0d84e3dfb8d02ee278c6380254590d592681f3ff99bd7391d7cc2ed2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e756d51b0b42f32b22ea97957faf5fe5c5841bf4cb1e0c7dfa93d40b0066aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
