class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ba369effbe0d9f556cbcdadd5882eeb6346a105c11e5f07ffccb7e834cadefe6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/container-diff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2898b404cdcdb47d75ad4069400f5d2d3d05ae2f75a94992c85ba0cb413a050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cfaa088dfd3e673531d526e3ee2d5944c9053d072e02bad34c54a4bfc52fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f6a6f3491565f8c9b363cefd180da62191b2195b880f5ac9a16301c16466800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e010839ef7bb91c0e7b3ab6ee2d98026c9a0388a9aa67e8015c6a7b3df3df755"
    sha256 cellar: :any_skip_relocation, sonoma:         "560bf523cf4f39b7c1998e32890701a84bcaefa91e0e5ef4f05f42fec3ee630c"
    sha256 cellar: :any_skip_relocation, ventura:        "7756cf737cf1e62421dcc1e22e2e3cac47ecf36a9c795a334ba63a25b7e1ab8b"
    sha256 cellar: :any_skip_relocation, monterey:       "04e68045306c93d183aa5724a64519e14afa6e04512039e455e9cc7b855b4d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47f4eb5a2a2d4663d512ba9fefca353f0508c9234e181d4a51d9d8dc0015bd7e"
  end

  deprecate! date: "2024-04-05", because: :repo_archived
  disable! date: "2025-04-08", because: :repo_archived

  depends_on "go" => :build

  def install
    pkg = "github.com/GoogleContainerTools/container-diff/version"
    system "go", "build", *std_go_args(ldflags: "-s -w -X #{pkg}.version=#{version}")
  end

  test do
    image = "daemon://gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1", 1)
    assert_match "error retrieving image daemon://gcr.io/google-appengine/golang:2018-01-04_15_24", output
  end
end
