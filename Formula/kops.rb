class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.26.4.tar.gz"
  sha256 "f4282b8d836c1cf3bd5ad3b05c98ad7ff72bc0b471731dc183c136491077d1a8"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e593a7aeb552a4b0aa8d1c386330d56b874419dbd92de6f242d4d462af63b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81793ced0cda20154b9134a552caa734387aa6a8c77f836e45cb684aaa000eb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e0e3e82c81159807d5649d92308d53ff564418711319c2de5ef435747ac8a09"
    sha256 cellar: :any_skip_relocation, ventura:        "9149e734d8534979a7ec3a454d8b30697bab00ba673f07105693d70108011bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "fb5f97ab19c5ce3bf06c47c64b2932b6688256ccb368d17119fe542b78579879"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd856256ac3ed992522501269d802ba91c9c784f6ff059ff660edc6060991728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1186a0ead00332e26b6849ed772af49d2ab770518f50d33eb58f98e73ccf5fd"
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
