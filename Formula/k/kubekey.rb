class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.10",
      revision: "58fdd469a88f4d5f4e734e62121b80cbd403d768"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1e2623680f2880c80650893d383ee394bd7c90cfb7f846143dfa7c8f46bc365"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec00141c7a8f328a745b5a8e5e3c94e60c398bf8be5abe29455be4800c4aee35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ddcdba72ad50838b35a4beed1454433aaa7b67aceab19174861b46dd3218217"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "708d7928bb550380a787050c67f472041303d8bf5f9b05f99384b01905d3d0e9"
    sha256 cellar: :any,                 x86_64_linux:      "a5678b77739f7d4afad2d089538e85475c9c63d575536d9b1b220a14db68691f"
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
