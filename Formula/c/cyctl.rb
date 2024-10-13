class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "56e7299bd7587d78001728b4f0ae15daddff86b42d0a0a70ab0de53b9fd6cd90"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6e51c76fcb690793ec3eda11fad8e1cc075d9e971a55af42d2c78624d959bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa6e51c76fcb690793ec3eda11fad8e1cc075d9e971a55af42d2c78624d959bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa6e51c76fcb690793ec3eda11fad8e1cc075d9e971a55af42d2c78624d959bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a7d24c42b7e875193bcc057b04a601922f87f00b01efa96ae482e04b9d9de4f"
    sha256 cellar: :any_skip_relocation, ventura:       "3a7d24c42b7e875193bcc057b04a601922f87f00b01efa96ae482e04b9d9de4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dcde3e75a8b08ff07a7b2b9db9e9e339a74254f3db1fa663ed0e47f66c56d93"
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
