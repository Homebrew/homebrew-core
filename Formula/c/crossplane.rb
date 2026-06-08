class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://github.com/crossplane/cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "6e7e5a7aaf745dd6d9fcf04fa19fc555d4f0a2df865f50a3c6a071173bb66373"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad59d19848d4942b664a835f038b9ac1757090488fe9343d2f5fa109959b22d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78d5e7eec42dc287d8e9505a37752fdc7ac64b80f1dd68b3f001b3c9e5797207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdcd74df714ee0f5e58aee452d837d8715df1fb1346f7fbc98c5b60f9aab5fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57d89ea1b69300f772645d5ba6a8abbbd62998c0b2d4447c25d5a6c14dc149b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc1ee70d50ae4c27696ee53de116de2b00d6c5de2bde4e4c45a95c598fccb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c3c2d10cf20cc0fc12a50eb498100f26d86c110bda9f0d4fbac6edc68b2c95"
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
