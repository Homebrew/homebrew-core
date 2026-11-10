class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "3e393baa5e8461429cca56118f4dd2c371735d7750429bf7792d4e83bb8feb93"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f2d411bece11898d7e6b3de3cb6f7ff700a812092115de9f8a0ef917941243"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bff25d1a1bd1cdadf615009f0b960b3cad8ab2150a8b612f84fa88330cb2ae59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de9e2d5d71a8c18f7b93aa89dca40849e02bacb83e1508b52519d85e64a900cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "541e3d6000f7432e508f2ca36b8352bab14581169dca533b050fbba12f149325"
    sha256 cellar: :any,                 x86_64_linux:      "5aa7257fd4ee9ce90b26694fdf54ee2d7d4634a8732a37595f8b5ae4e438d10a"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  deny_network_access!

  def install
    ldflags = "-X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
