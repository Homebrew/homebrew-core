class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.6",
      revision: "ee6a16ac1ad781bec21c5f2594b814d5dfadc0e8"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371603592958847cfd4f4afa0072f695ec0f81267626b2347b981756308c6b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84626235a5543487831aad9b113b738ae14afbc4f4a2bfbbe1aea1be7cf95687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "630ba0a5a3c0beb1feebb1a0bf5d042ee45b73b3b80d45152c2c8cd5c924617b"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b4e483193c17e0e7b2898f04a76973fecf8861571afb03656f179d1a311d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f701d40a6ac36cdb14541a5950fc09624830b0db90117553cc2b8953b689bae2"
    sha256 cellar: :any,                 x86_64_linux:  "1ad095bf766d55be0458221e902888fef8808e95f289aba27634ff78b30a7e79"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kubesphere/kubekey/v#{version.major}"
    ldflags = %W[
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "builtin", output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end
