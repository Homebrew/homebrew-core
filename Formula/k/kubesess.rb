class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://github.com/Ramilito/kubesess"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/3.0.0.tar.gz"
  sha256 "827db2afb33e5dac69dd4690ffcbff91a17ad6b5c4fe21c61d1ed39c7a7bc099"
  license "MIT"
  head "https://github.com/Ramilito/kubesess.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229eb30598b36318c4010ea3cc4457abf78cdc6ac4f7c32fc4438e0b959141b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f4954b43873ae467b0e67f6cb4f144224522a0f862488e020cfb0fb3421176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc257d9edf72d69b3babc7d4eb6e0345c8c7dd3c3adef0f96508d1e2977f8e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5b50a690fd167806e2185b97c89ac786d16fe34cb0a9fd701578358444822a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d5c7d1e868618f87b1dd7e942135517a49e97cca4da734c37501d9720ad44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e095429f8ef728a0ee55dca2f88e2894ba2efa6f0052ad396f552c7ca06e37"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".kube/config").write <<~YAML
      kind: Config
      apiVersion: v1
      current-context: docker-desktop
      preferences: {}
      clusters:
      - cluster:
          server: https://kubernetes.docker.internal:6443
        name: docker-desktop
      contexts:
      - context:
          namespace: monitoring
          cluster: docker-desktop
          user: docker-desktop
        name: docker-desktop
      users:
      - user:
        name: docker-desktop
    YAML

    output = shell_output("#{bin}/kubesess context -v docker-desktop 2>&1")
    assert_match "docker-desktop", output
  end
end
