class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "dcdd06b770a6b697c8b9ba25ea7a96e4c8dd1fd4938a659ba49561f027cb38f7"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "225405ddd4eb2794e84e5e05d2c1fa0efeac35a8af825663a8d4f9fe0500fc71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2f1f1e259006e374d12cf9e5639c3e5c3e5be8875d29007876f139bf855002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5419bbb090cbdaf3e53ff93b9c2a552c0538d597389489a017f1d52a263548da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73c6aee4d00a87cc71fd82a5baf877b600a02a7d749bd126367dd8c35fb42aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "14e107d4a74a2bba610e2ddda7851fe24f59ee63d7b076134cdd21772e2b302b"
    sha256 cellar: :any_skip_relocation, ventura:       "dd0f4e555ef54697b0abde16f136258898c3cb80a2615a21ed9d0609629212aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7bc62e23e11691f46e8db131ad0eb7beb32d0c78907388732b6df3591a0880"
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
