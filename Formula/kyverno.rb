class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.6.0",
      revision: "5b4d4c266353981a559fe210b4e85100fa3bf397"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    (bash_completion/"kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "bash")
    (zsh_completion/"_kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "zsh")
    (fish_completion/"kyverno.fish").write Utils.safe_popen_read(bin/"kyverno", "completion", "fish")
  end

  test do
    manifest = "https://raw.githubusercontent.com/kyverno/kyverno/1af9e48b0dffe405c8a52938c78c710cf9ed6721/test/cli/test/variables/image-example.yaml"
    assert_match "Policy images is valid.", shell_output("#{bin}/kyverno validate #{manifest}")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
