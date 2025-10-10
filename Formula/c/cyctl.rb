class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "f5c14b153cac83b6cd401eed86df219dce0fd4a8843858104cb470bdf691a714"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f07fdf29bb7e364b84535e67758c692c44763a245bdb63eb718135d16ee79188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91093fae1c86d9f72483bd78e6b3d24257276cfc656ae5d62637616e301024c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a91093fae1c86d9f72483bd78e6b3d24257276cfc656ae5d62637616e301024c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a91093fae1c86d9f72483bd78e6b3d24257276cfc656ae5d62637616e301024c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a8bf0780b4bec03bda21046b752f0ee013089ea7b6f988b0a4ad0c914cf6ee"
    sha256 cellar: :any_skip_relocation, ventura:       "19a8bf0780b4bec03bda21046b752f0ee013089ea7b6f988b0a4ad0c914cf6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763911aa14516e73ccd145994385626fe1fba341bf34b3cf974a9d98fdc2b016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0f445325ef4060e628b0ee17b4204e6263846f482632163913e45aac934ecd"
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
