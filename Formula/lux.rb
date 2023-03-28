class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.17.2.tar.gz"
  sha256 "eaf08b8cdac14504307ae31920d3d094101d901cd390436ca401b3ba1e7a8924"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b632e988ab9acf91455e1015ed283e2fe7db3e2e86bedb4810715f890aacdb81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b632e988ab9acf91455e1015ed283e2fe7db3e2e86bedb4810715f890aacdb81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b632e988ab9acf91455e1015ed283e2fe7db3e2e86bedb4810715f890aacdb81"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6988a8e9823ea323ee3f110deda0f5627a7d75c07373104168788ef6061546"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6988a8e9823ea323ee3f110deda0f5627a7d75c07373104168788ef6061546"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc6988a8e9823ea323ee3f110deda0f5627a7d75c07373104168788ef6061546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828fedc7038f2b176f6f8c74683736dcfd1d50e0ff7224519807bc11e9bc616c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
