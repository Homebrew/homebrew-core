class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "6973819433911b28c4c71d4fbb84e9fc377576b25f3b6b435a1f1276fe96bc87"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "438a11a5d6470e3c613a21052ffb7f35116a90ebb0721dc390cf752b20a8a5dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf324ee3cf48a78642ed4a3a165f4c9a2dfe0bb572e087500282c09c78ead230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc136fc7f0754f285b79a0c9b6976ff0b9f2798ab944513e99f2a56de247afc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a08c62b40138a14c1f7bab4833331d8be46fcafe90d55f398fe8f204be617607"
    sha256 cellar: :any_skip_relocation, ventura:        "beeb04cb2f0abe5fb554c814dc44a41eef6b9c76b241cad0aceb0d8d0e059f73"
    sha256 cellar: :any_skip_relocation, monterey:       "a3eb7c62afaf9751c4827382f0fc2066742d684d91f5ec3e314868f61dcb6bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb331676b6bd0b7ed4a202bef7493ab5c78fb9be71278c50d931a668006383c"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~EOS
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
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
