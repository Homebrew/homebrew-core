class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "03b0f968e813ed8da6a214fda9f1534f27a65f868afcf892d7691354e59447d2"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ab7bc5dc32177099d8d06d92a2d34f984452db61d8ddc662a0417e2116c4b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ab7bc5dc32177099d8d06d92a2d34f984452db61d8ddc662a0417e2116c4b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2ab7bc5dc32177099d8d06d92a2d34f984452db61d8ddc662a0417e2116c4b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d436335786a87c78d148ed9baf8f0f2370b29cf616e3e51c8382d5658edc53"
    sha256 cellar: :any_skip_relocation, ventura:       "31d436335786a87c78d148ed9baf8f0f2370b29cf616e3e51c8382d5658edc53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d5eaff345b273e61149b9eece8cb682e4d63ff4c7ff7474edfafae7b80c860"
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
