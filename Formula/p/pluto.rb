class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.24.3.tar.gz"
  sha256 "0768ca0d76ecafbda4c810ff52dcb3b2739d9472e3f251c6673626e8773dd1db"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58e0ddb3c45d3398c260eaf9ec3528a80b09f0453224fb2b651ce0258df27e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58e0ddb3c45d3398c260eaf9ec3528a80b09f0453224fb2b651ce0258df27e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58e0ddb3c45d3398c260eaf9ec3528a80b09f0453224fb2b651ce0258df27e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "467aafc338ed8f2762c76c4f337a4340f91fef789636f1b57cda32cd9b8177cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c80598275eeb984cd64fc71e1422581c0387f7d1cf6f332ad06083d03a0162f8"
    sha256 cellar: :any,                 x86_64_linux:  "406a26cebf2851eee248b6311aa99725f2c0c9123a9bc04adfc7f75b5ea42d01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "cmd/pluto/main.go"

    generate_completions_from_executable(bin/"pluto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
