class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "16e8cc80a6d4403baba7c56a76807be48ef6add32172e3c80c58f17bffdef3f7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27c8e94a0d9bd8b49395e1961db29af7aed84e8e9f287526accc778c6bf42614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f36425cc9292e4e99e06840958493a0c94ee8d0952a2f6c77c6aeb690244804"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e185c45a6b75794c2b88dcbb02e61580a970415840fa4f10156e84e413a4004"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9a8c8c7e9b9fe9ee80ae48f92b868a6e20ba382720bed456818ad5b1110b686"
    sha256 cellar: :any_skip_relocation, ventura:        "e3417f17964b61b273ec7a6955c606ca56df9f23615af2ff31a21f515c4bcc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "6fb041230bcbce1add07eddda0d9490f9279b16ec208873ad1f0ce044d42185f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821c07d350ef194e4f6c02e0236bd71a503ef303747b131c5b8d2b9c74462836"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
