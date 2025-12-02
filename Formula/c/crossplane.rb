class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "6f732e92e3d10ce46901f03d90770615fa4b20da1504bab12eca95b5233d4f18"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6696eca6177451218fe647b513ec7fe76b806b02d8e5f5585f38ff303eb85cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633948dbc5cbe7f0b9bc3e3488afe1fe49716d06c5ac5609ddd47171720706c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb7f2978a6af0d74e7ed37a803f793367328d2e56bc0851280cc798a1111f632"
    sha256 cellar: :any_skip_relocation, sonoma:        "bedd28d4162b88f30d4a237fba10aa1c66d71cd4c481ad33f7d73b6dd0cfa2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8520eba02f936920b53bc058bfdfd1e12c275c556a035e4c793e6a737abd0f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8730134aa8fed7a4d6c4a0be8ff4124a8ac525afe4f7370dfd1a047e64e6f030"
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
