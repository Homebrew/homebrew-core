class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "0dd1a190b35669d28bd6ec8f78497ab4a418911a648bc71d2ed9de98e742bcd9"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e648f8f7b547bf7e3ded9fef5d6cb4aa12a5d16aedfa00d5329d2cf6b996db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c0cd9f656f9f386ec0a0f82931de902e0442b6b0a7354152906aa9530f3ceb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9c25df1e905fbdbb23a546b21728b3a1700cdf2fb39c0d821f489c3151005e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b4ffd5adc274f272b7c4fedd4c3e6534ac8e4382761da42a0cd0e6971536d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "114c48e1b6d34aac73824c6d4ad8d8b7f2174f53a18e387887efc38a9b3c1e83"
    sha256 cellar: :any_skip_relocation, ventura:       "0c85bf01d942a4faa8efa0f297624e78d07093ec3791403a1f82eff42a66688b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7571b42dd3c7376fe86910a6b0b7f7e7bec628b4dfc28eaf7fe370ed5633b56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998a4454d3ef6daa71848d3659b0aec2f1c12fb35dd04c2e26a3c2b0fe51fdd8"
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
