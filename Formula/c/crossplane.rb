class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://github.com/crossplane/cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "a88c0068f9d6f5a7589d5a0ef21ddb3268e617d709e68d25863f13b60ce6d5f6"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "713c34cbd9a3951d907b8bae70b3e605996bf7375926ad05686a00ccb38784d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a462f8b1785494d2fd3a184934a56ca44fbded226ed233afe2d9e1b58ca2c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13eb4045d85d373b5eaef41f3b2f22cbec0269740e0bd2e2584febb68c5538f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ab41885929f315f08a592a9924a642d32f0206f9acb815acc6298973a0258ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0355e7520918ddc2530db7d0568d405cbc5fe47fefef063c950af576e4bb5386"
    sha256 cellar: :any,                 x86_64_linux:  "c5f32b36d92bf4cc949386dee8a71594a7d5eb122726cc419098bc9a38a64a32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/crossplane/crossplane-runtime/v#{version.major}/pkg/version.version=v#{version}]
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
