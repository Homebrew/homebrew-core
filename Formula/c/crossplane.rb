class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://github.com/crossplane/cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f118463fd03cfbfa35b677514e7b6b96864540134e6a3dff2c0779f8c1d0080f"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66f3abad0e25e986eb60746eb7e7989e391438875f57aaed8c3132813305bb2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a2475fbc4711846e14708074b5fb40e71ffa9679a7e14dd9faa251aebf7238f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "746aba28f5b3912a153bfe8cda810778261a31443ad1405f542502470d089e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "af4bf73b333311ca6ea7816afe1cdf8ef1031310087b428c7478e56e1086c2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56286ed93d64249bb703c69cc445e49c164a9ca466289467c854272d038636b2"
    sha256 cellar: :any,                 x86_64_linux:  "3ba7cf7011683b79169a0a3eb594e924dea62131697ddfe15e7837fe57d111be"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane-runtime/v#{version.major}/pkg/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crossplane"
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

    output = shell_output("#{bin}/crossplane composition convert composition-environment " \
                          "composition.yaml -o converted.yaml 2>&1")
    assert_match "No changes needed", output
  end
end
