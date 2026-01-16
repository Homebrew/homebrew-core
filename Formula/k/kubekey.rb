class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v4.0.3",
      revision: "5fd34cef73a94de91ece59d3b326bce393ef6dc1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cf1e1e270e45f2f0c71a2e47ca3f213579b3e1b57e7a186f0bde712f6954968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88917ffc11e16e9ee8ff770c18aa6fb05c2cbc887256cdd53b07947b814425d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "907607f48c0381d26bbe9c7219a406a9d35902b188505ab99729ff0fdd71e0ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da8e134ee43aa2f7c2c320e7c07c19256934da0dd8bb06f514049b8383c6e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f39cc3005108ed21edf994ea1b6af7bef7606c4adb18070f79ebd90fa1cd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225744a3ad43305635d073bfd6bccb73aef6f00cd9443ceae809935ca7449e9d"
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
