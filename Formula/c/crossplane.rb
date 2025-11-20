class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f6815ef717dfdab20a83d979876309984638d8ce37e50657739d7d4a53334898"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c103e3b0b86e1c01c04a64ae46033452be3681a4bafe7eb7399f7a1bbd7c3f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247ac982ddd1a11dcfa39f2d56caa09bd8686ccc73e8b462e2f1d0b09bd7e6bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b400b8dcf02382f322eff061bee54499747fa99af695e9255c2d778d7c75e3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ba09b512ec8738e91ae1a95a6f36035443d8985819385a9179dc3e4115fbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7825ebef7009586c11e8fa5d9bccfd3ee3f5fa29cbfec4b026e0b6008d34f571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5233eb709d29173cd4d2a1e5254bf6016323db5f864937bd460fca55f3dcb1ad"
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
