class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "0b0149e37743dae57f6a8923365e5afc6e56aac16bfc4171fa0379b67219b1b1"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18e81f1842d84d0c0e21ec536aed04b04e5abbbc20f2c3624641d55c37c5bc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4836b5f90e5ca20179cab628f06c094e3dba9c40fc477d7ee8a4003e71c6d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f33b9adb8d17764c9ff82aed5da893fb52dccce85acc5e4a8bf80a1cf108c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9247214b1aa8565d2e5705bf636b4b69e9e88b8ede46ab122321bce8f91174f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94e7c908f93bbe5dd524d86ce2e160314f5f0911fd44fc9ddbb8bb5afdd7c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d926dda317d6c98ceddc525e97ae34fd0299ac501ecaabbdf1ac27efd2efcfad"
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
