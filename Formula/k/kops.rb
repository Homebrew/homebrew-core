class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.27.0.tar.gz"
  sha256 "b5d5945554e41ec335917a22710484f971c01af5df0ca5a50f2e9a91b3abfa33"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89ff0530fd886be8d8e7ed3e3d675e4f9114cc07badc25a28118aeb19b0ac52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c76430e503f81efd5832771135a75288b94b9aa350e93bf43bf64db4e4ad9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c215aed04d69b0ca38252831a96b3c361ed9acd862056da085fa78feab07f00"
    sha256 cellar: :any_skip_relocation, ventura:        "c50001709be6a53b5b6c548ac975f95e97cec00d2329f0e4aeaa2e29816d8d04"
    sha256 cellar: :any_skip_relocation, monterey:       "60c2c2e7382fd02e70e37c2a972bd6204da488c4f02a36c4ddfae1904c415064"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a96ed71c96fb84136b3979c7b2727b6a6d4724ceef040fd669932ffa3249af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0abda224246bdb1355596ff65336531a0bda7499074098190e78fa42a616cbfc"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
