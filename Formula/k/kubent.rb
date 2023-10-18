class Kubent < Formula
  desc "Easily check your clusters for use of deprecated APIs"
  homepage "https://github.com/doitintl/kube-no-trouble"
  url "https://github.com/doitintl/kube-no-trouble.git",
      tag:      "0.7.0",
      revision: "d1bb4e5fd6550b533b2013671aa8419d923ee042"
  license "MIT"
  head "https://github.com/doitintl/kube-no-trouble.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "214848972f43b1cca085cb5a8e794dcef31ac5fe6609320e419d20db282ed0a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b253c116737aa11ffe96165128063e0cfd361ebb4b83cecadd4e58cb4a67971a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cddd6fee8427d67e9261d1cc5cac91245c2564bc20375a7b53a2106b610e921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24cc7e7c89661ff0f22472460e3f00af8943c823f36df5efd070e24dc5cafaf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "389b209ca28356e1638ccb01f5fb0b06e9b64dde341eb45b061c5f0caba818ad"
    sha256 cellar: :any_skip_relocation, ventura:        "e43bb284c4c03fc17bb739a5cf85e5961cfe490e025044b4777fa383921840e8"
    sha256 cellar: :any_skip_relocation, monterey:       "51299269284628a9ea395e29c88a464ec4721da7148e1b269dbea1c18356b557"
    sha256 cellar: :any_skip_relocation, big_sur:        "c00f175140366cdacd8f3595c6470ed0b967fda98a09ffa0eb51988a4a2a9331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4f92a7de119b79f18b88aed128a6ca80847a6f1f0837b69c992469ec40b43b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitSha=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kubent"
  end

  test do
    assert_match "no configuration has been provided", shell_output("#{bin}/kubent 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubent --version 2>&1")
  end
end
