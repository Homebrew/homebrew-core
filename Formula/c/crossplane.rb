class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "ad9061b726f1e47f47253b1769883bd967e2127c2e17d75b86ded4c15ca96cec"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71035ed1f8dc8b3e3d1e767e50e549b4821625e50134c212be5e4a3353e9f677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97cf587120505ac1ea7a7e62d48e42ec1ca00c47630d643f2ab7e1c1da7943bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1694dc6c83a6af8144032decd61a89e8c31f6bcea3d413da0109b20086eb318"
    sha256 cellar: :any_skip_relocation, sonoma:        "f20709f65e01dce680b7464e759b96657a989a8bc2fdbd353080a52700bc3be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f7c57c7115dba546088c0a5cbdc5170537597cfe51ba1273c4d7f1883bcf975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb81d05a4015a6646b61ab88d550197a8bf28d5fcc8a4c53cb07d095c5976a98"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane/v#{version.major}/internal/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"composition.yaml").write <<~YAML
      apiVersion: apiextensions.crossplane.io/v1
      kind: Composition
      metadata:
        name: example
      spec:
        compositeTypeRef:
          apiVersion: example.org/v1alpha1
          kind: XExample
        mode: Pipeline
        pipeline:
          - step: example
            functionRef:
              name: example-function
    YAML

    output = shell_output("#{bin}/crossplane beta convert composition-environment " \
                          "composition.yaml -o converted.yaml 2>&1")
    assert_match "No changes needed", output
  end
end
