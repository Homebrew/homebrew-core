class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/cli"
  url "https://github.com/crossplane/cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "065237cd2d8da289804abde5d4a74bfedb84fb39df83d28a5843da5aa8dde69d"
  license "Apache-2.0"
  head "https://github.com/crossplane/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e61316ea7032cd490b5a066658c11dc63df7ba4be000e97ea54d8cc29467198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2a33469777e6f6b0ce9313d328998c198fb5209788c3b176fca48f557d3bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136d4a14953a62ea5099476042d1526ed7fb0cc60a84a16d961889b975e976f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8997877bafe34809afebe36bf6a691ad83a3150d8ac7277bd18273382aef58d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfab2abbb47053892529a546f23a1b182e698cbb463e572cc29736882367dbe"
    sha256 cellar: :any,                 x86_64_linux:  "7f65d8be77467b09a4dc078a259df9cf733c7ac65f48027337f2a23c9c52146c"
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
