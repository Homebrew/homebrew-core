class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.6.tar.gz"
  sha256 "bfaff80908ac0d7de1c574ed9bb634cc592588b9abc66f48b3502e13e38b27ac"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e835e0deb45fbeddbe5d788c1ed2b46f361a056a580b0cbb3ac0dbc0f6de4e3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e835e0deb45fbeddbe5d788c1ed2b46f361a056a580b0cbb3ac0dbc0f6de4e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e835e0deb45fbeddbe5d788c1ed2b46f361a056a580b0cbb3ac0dbc0f6de4e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6df298500debcbd30d28ad8fc8b4811a0d51675585a18225089b7de73e10167a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d973b32e8f0540312bb5bb7d44c29725129705c38a36e342a9097f2ede3bee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe65dbafaa3c2b53f75735635d465790e94533ec1dffdba53be4e16a8699a25"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
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
