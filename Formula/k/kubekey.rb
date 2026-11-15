class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.9",
      revision: "0cb245f681f91f1305fd1880f292076e21343dab"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb0abd3a1eb5b0b485fed992309e7020fd80f2fb3448900800fab8c33a9cb5c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a16c15a563d73d1b15fb3a37e7daa96d409dcf7d9b3319778f718631bef512f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42e1a4948cf80460edc03ab44ed61298d337c8756e963d82ed5fa20fcf54d7a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f84e56a5dc8a814635055e2b4e8c164ec3a8d2fa309e3416b7bf0eb6ad042e03"
    sha256 cellar: :any,                 x86_64_linux:      "8da8a4f5a9793e7875919b3aa381467ffb0689d2e61faad42506f2dd6c6ba6ae"
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
