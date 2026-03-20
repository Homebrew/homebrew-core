class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.23.5.tar.gz"
  sha256 "4ce9716ebf32f6c89772582520038d5da09712044b7bbbaa54b3fcdbec9953bc"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91dbcb2bb7ab4e5de49e236d34463ccda477073a932e85e777f12cc6837abdac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91dbcb2bb7ab4e5de49e236d34463ccda477073a932e85e777f12cc6837abdac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91dbcb2bb7ab4e5de49e236d34463ccda477073a932e85e777f12cc6837abdac"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd7ff30db015940bebb50603e85f4a952bfec1ac8659e0d899daafad8b686ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f8a75191ff08a3cffbe8c69d3bd791abc07df77820550c0b52bbd6712f2c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96aa0bb5197d0da131c1510d52d5d74b2b9f03379776537864cab42ebffbbe6c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"

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
