class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "03d5017a720318882926914198ed1c61e9fd89c24ca4cc89db504a346b0e789b"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9f2095b07b4f4d9b47e25e2d641087eec75fda10239d623b7e266492e65ac15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f2095b07b4f4d9b47e25e2d641087eec75fda10239d623b7e266492e65ac15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9f2095b07b4f4d9b47e25e2d641087eec75fda10239d623b7e266492e65ac15"
    sha256 cellar: :any_skip_relocation, sonoma:        "5667b60a8bc30bc264896245ae4542b144880e4dcb35b6de590d8ec8ecb33b15"
    sha256 cellar: :any_skip_relocation, ventura:       "5667b60a8bc30bc264896245ae4542b144880e4dcb35b6de590d8ec8ecb33b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71cf6dfe33db7cd4aeee365726c1bd2e08a627f9aae1f78f6991b2836a084e2a"
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
