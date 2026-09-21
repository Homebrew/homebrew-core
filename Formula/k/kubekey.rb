class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.7",
      revision: "9b38d25d6514758afc97559dc6f111eda31a4e82"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20882405fba3140c2a898bcae88b82a8ebbdf6831c47127f6efe8ef1c843682e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d9878a9343438118e1d2506adf233bb1384a5563483e270829ccd8c54ff4285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85fbd36d86287996d5fba47f3142e74ed848fffb8a5580de10223a1e9c454536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "78418d934a73a22955aba598f9a72405447cfcff92789c7f403200d80ad6e1fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ad1ba802345cfc0cc7d531aec16a9debe1327395f97343e60192080964bc1ec"
    sha256 cellar: :any,                 x86_64_linux:      "41a274f5c833e38e5c5572f13dc6b0c61dc810d5423aed73da1438c9f7fcf156"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
