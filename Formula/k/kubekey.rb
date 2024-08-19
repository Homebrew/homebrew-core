class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.5",
      revision: "8347277057bf9f84e89fec174019a675d582b23b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df5c7c66d3222ddbec80a7cab9a7c3476d03ce62b7c7f3f24b01447865c017ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ffb9a5299a149ee67afd5d65a88747403fea3d0a5ad3df417d5bd18359f39fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9acc9d00e909093a65c61a2150f126304ff1cf22e2c9eb2c9d8aff134d312763"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb88f7dc9b01530010b7243e91115a99a7d78e8725c5daa1ad015f7053b1a751"
    sha256 cellar: :any_skip_relocation, ventura:        "d6cfd61b862d4f64f3f7268283a1f89ce6de27a2c5cfe9f7458a36d0f825f990"
    sha256 cellar: :any_skip_relocation, monterey:       "28c3c6f00f42a115e57e0b0b0ab598d6f96c55677305a1f909bc6d1f2fc3c8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb9192c946fdd10266c0757b2b9d8da02dcb6f5b1b687089e1aa3707d299efd"
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
