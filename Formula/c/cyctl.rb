class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "8c5fae98e359492b827c1e8c9476283761abb65a8e3939b3f810293392d373ae"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0045988672242a12cb2d1d593c83294efb255e0f736663e2dd5371e322702178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0045988672242a12cb2d1d593c83294efb255e0f736663e2dd5371e322702178"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0045988672242a12cb2d1d593c83294efb255e0f736663e2dd5371e322702178"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b50219829c412e2ffe213bee6024221ced4c111f25c18c758e19138915aefa"
    sha256 cellar: :any_skip_relocation, ventura:       "69b50219829c412e2ffe213bee6024221ced4c111f25c18c758e19138915aefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b56c5e12974df129db3070574f1dc6bad9c6970e055fe3c5323dd973772910"
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
