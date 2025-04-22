class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "32ffa2c1cca51b41a21dfc00e8c043c1affb5ee2fc210ac3f19439b73eeb6389"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffd9d1051917532ccab9b4892885a9ab98f7124a8f69f3346a81bbb79aae1bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffd9d1051917532ccab9b4892885a9ab98f7124a8f69f3346a81bbb79aae1bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ffd9d1051917532ccab9b4892885a9ab98f7124a8f69f3346a81bbb79aae1bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0dc086b3882ea1c4bd3d95aeb8e9d3bb8731483b3db4abd6307f90d972d4b69"
    sha256 cellar: :any_skip_relocation, ventura:       "c0dc086b3882ea1c4bd3d95aeb8e9d3bb8731483b3db4abd6307f90d972d4b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22115c04cb601bd7f1c42f26e325fec6dcc0fd13f26551e05e22f52f4f864be5"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    YAML

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
