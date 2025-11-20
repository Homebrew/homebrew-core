class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.1",
      revision: "423d9f1b33010a16ec848f12cc6c4dce25bfcf26"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2beee57e32ed76da9e3e74b6637befb629d62c29a31b7b9b34b9f79b555efa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2beee57e32ed76da9e3e74b6637befb629d62c29a31b7b9b34b9f79b555efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2beee57e32ed76da9e3e74b6637befb629d62c29a31b7b9b34b9f79b555efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d7c39224ac726557a7aec8f8f50ff9b993289b9cfd8ca2c5c853f323be89d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e7073ee8c1070db4db067de24d3f1eee7ed9457ac4386a4e09f2d128735a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd33ed887539124a7522f946a9b13fb0d92597f3d6171a754633e3c85f4e1246"
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
