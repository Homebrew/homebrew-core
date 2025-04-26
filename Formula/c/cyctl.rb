class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "57242d18a226e65f08cae1596b55b8bf57f873c49879ef690ef74adcc0504a00"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353da5216c9eb3ec04b5f4893859f898b8fa9cbaa1c5c5bb504f16ed290b4088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "353da5216c9eb3ec04b5f4893859f898b8fa9cbaa1c5c5bb504f16ed290b4088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "353da5216c9eb3ec04b5f4893859f898b8fa9cbaa1c5c5bb504f16ed290b4088"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e22d493318a7c5aa66739c58f9edf8dbcde5b98d99ec8884107a28c497ed29"
    sha256 cellar: :any_skip_relocation, ventura:       "69e22d493318a7c5aa66739c58f9edf8dbcde5b98d99ec8884107a28c497ed29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427e1baa267bc9c33ad83de966b060f5581c1320f9166a3b7ffe065ff8c52f07"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    YAML

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
