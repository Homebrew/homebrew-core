class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.13",
      revision: "ac75d3ef3c22e6a9d999dcea201234d6651b3e72"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb5102e00c5aa4a615a0791db06833a3b438a64036b70f428b5abc92034ee2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e55f19525002ae0a11c1f6ae5c333ca80dbb9251157d86774436e11e1161f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d511f86725b84ad888f51d3cfe66906390a842b63c986b97509725da11e397d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2234d54a0db1c84a979db5c84c007d2e98a4c7d5976781c5b81ceb95ebd5b37"
    sha256 cellar: :any_skip_relocation, ventura:        "487589ef4995728082847e7e7752f058940014fa9981b7c0f628cc63c6c369b2"
    sha256 cellar: :any_skip_relocation, monterey:       "dc5a3942404c0ebfa2fd1977c36d08edc50fa96adf9e666919f87a8ea9cc9f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae9aa8927d089f5b58248795ecedd59ca34102c4d3d401f5b3297f19551a9a5c"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    tags = "exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"
    project = "github.com/kubesphere/kubekey/v3"
    ldflags = %W[
      -s -w
      -X #{project}/version.gitMajor=#{version.major}
      -X #{project}/version.gitMinor=#{version.minor}
      -X #{project}/version.gitVersion=v#{version}
      -X #{project}/version.gitCommit=#{Utils.git_head}
      -X #{project}/version.gitTreeState=clean
      -X #{project}/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"kk"), "-tags", tags, "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
