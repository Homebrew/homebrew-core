class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.27.1.tar.gz"
  sha256 "a45fb4c33ed44407121330462f4c323e9cdb70d46b8112e3ad78fcaa5b00ee0f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e238c97d5a81e687269997a7957c162a659290c8b2b58c0797d9cc45bf818e07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "462c3f3237f9e470db2c39de1f5adcc42f0dc804dccdf4f11c4489599b459661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1344543f768455ccd36af26a969076a5d4dd2cfd33f52ece4026f3e19a33a353"
    sha256 cellar: :any_skip_relocation, ventura:        "d141b0780d588bcf94c27853ec84d0a23404e6062b7f887b34161f5129cc3675"
    sha256 cellar: :any_skip_relocation, monterey:       "a1e6ea01ea962db198bfcb8647a86e11ac192ea0f0c2f4d7259464dabe79c883"
    sha256 cellar: :any_skip_relocation, big_sur:        "55d851839999d925cb102d2ddb787a830808d0628dac748de0bd2fe395fda070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1869d8f197371d900fc022f3cf50dc8ee1269a0804f69acc24d4f134bc467be8"
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
