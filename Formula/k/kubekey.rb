class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.1.1",
      revision: "7a184f786b02bec20d5534af137896f50e510396"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6d5d8fc453fd371a7cdec5df794266e0db2f8a2edad0f9736d3c9f089ab313"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25633d1c28230f3b1fa67920eb34deb372fef4db5ea96ebf45397469a43668c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11bd5e98008450a8cbfae16c2dd35b4c6c087916b3c0cf9ff990978968b6cba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c8447378950cc651d11a30bd69bba7bf898c3d7395d00df804728a6c7554fc2"
    sha256 cellar: :any_skip_relocation, ventura:        "8e048ce2d385706851dbf46bebf14f0a6ee947ec5617855488f8d94d7c611293"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff0894d682ad71db936be3eba86cf893bdcc3e01df76d63ff0615f1a6a101e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd36495a72ff57963d045c48d48be0894b0db69844d6d58c08831d87dab2ed8"
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
