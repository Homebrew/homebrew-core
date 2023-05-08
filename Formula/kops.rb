class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.26.3.tar.gz"
  sha256 "10959b7b59f61a6078471eb2da30ad8c839fa96f648c2c9606a3deafce36eb91"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e577ec3526179db9c533f07d39817c801fff0770a940192c95ac286d2c4b871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "807f43e030dc44813a4f281cedcc7f0f5d771c10615b0d737dd9fd225d6ee17d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc040e309c2ae5d361bc4a0189acccb56b199ab96e9c2361726ef02a5819b3c6"
    sha256 cellar: :any_skip_relocation, ventura:        "ed2cc7db2f70d8a9615548aa9ce9799217a7fe016fbfe312ecadecf55fb51ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "9703c234d57af288c3f79e05856df94f852a9af6ae1cc50dc0921ca4d9665bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b3e2b2195513df809d461faacdfeca3f7a437ea9ff3aeaf58fae6be284bb92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5923d9f7f0765babdba20906a58db20172e698a1b9e79f3827d69c6f50e45e5c"
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
