class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.3",
      revision: "fd08c8caab8116f87810b5cde3313a7cbacc53fb"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e7ccca03b7e117d1f5ef89b40483bffc6f9882682ee0351e3277b131a90fb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf42787485da8a12098d89821019ce392313c576d9f225f7b283ffac1ad7ae45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6a2052c4a4c2a149ae71ee16412b6067a3aada9e64750e7b8bb38f5180d621"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c0b5a907c9c562a9950487ad2d1e4d12944af310aa1a7ed500e97efa3c9e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8263b2f8d799fca7b87fa4e0bab9a6dac2bc347b4d82a1522e5e366b5f6aaa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3c11a92a99856a4adeddf811f6309cb77bc4f30b5a3dc32fb47508d482e7f9"
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

    generate_completions_from_executable(bin/"kk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kk version 2>&1")
    assert_match "apiVersion: kubekey.kubesphere.io/v1", shell_output("#{bin}/kk create config")
  end
end
