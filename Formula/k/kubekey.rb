class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.2",
      revision: "bd780ee397ff2abcc5d03975c32dae056ddb86c5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e5ff2229646f41b5b9b0c7ea09497c772916e85f9d7a54f46a30173c3bdb6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e5ff2229646f41b5b9b0c7ea09497c772916e85f9d7a54f46a30173c3bdb6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e5ff2229646f41b5b9b0c7ea09497c772916e85f9d7a54f46a30173c3bdb6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8161cf22913d66584cc9117ba42fd4238abbe1fd62eb5503688acc4247ccc0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff797d16e6f6fa8976f675298a1aefc8b279467b63514b9dcacb93604e5c9f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a35b552e2d0dfd91cf636eeb13c85e9d003aab0c3034fab20b5bc433d5e312"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    project = "github.com/kubesphere/kubekey/v#{version.major}"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "builtin", output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end
