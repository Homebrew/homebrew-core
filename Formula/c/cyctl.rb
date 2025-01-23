class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "6d23615f63b5b735990287a68f13c563b8ba4acf51fb5b9eb23c15d25224a9d0"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85fbf44df5e4ce37757964f0315f6072ebdb9eacc2c446d00e183ce3ab095d63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85fbf44df5e4ce37757964f0315f6072ebdb9eacc2c446d00e183ce3ab095d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85fbf44df5e4ce37757964f0315f6072ebdb9eacc2c446d00e183ce3ab095d63"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b09930018f5412dda4368f6e1e926f0618cfaaede8e82ea2d478a4533bb390"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b09930018f5412dda4368f6e1e926f0618cfaaede8e82ea2d478a4533bb390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ff317817e1614a061c53d40da81fc8420658da0f495554062f053b06053463"
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
